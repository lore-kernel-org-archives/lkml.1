Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZBNXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZBNXSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZBNXKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:10:41 -0500
Received: from mail-fx0-f25.google.com ([209.85.220.25]:44841 "EHLO
	mail-fx0-f25.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbZBNXKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:10:40 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2] drivers/isdn/hardware/mISDN: change type of hfc_jiffies to
	unsigned long
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Date: Sun, 15 Feb 2009 00:10:33 +0100
Message-ID: <20090214230701.21991.75646.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiffies are unsigned long, make sure we fit in jiffies store variable
on archs with bits per long > 32.

Patch suggested by Jiri Slaby.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

On Sat, Feb 14, 2009 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Hannes Eder wrote:
>>...
>> -static u32 hfc_jiffies;
>> +static ulong hfc_jiffies;
>
> Ok, unsigned long would be nicer. I though it would be implicit when writing
> about ulong, but I see not in this uint-et-al context...

Uhm, it was not clear in this context, as uint is used all over the place.

Thank you Jiri.

Best,
Hannes

 drivers/isdn/hardware/mISDN/hfcpci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 2bb85c4..641a9cd 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -57,7 +57,7 @@ static int HFC_cnt;
 static uint debug;
 static uint poll, tics;
 static struct timer_list hfc_tl;
-static u32 hfc_jiffies;
+static unsigned long hfc_jiffies;
 
 MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL");

