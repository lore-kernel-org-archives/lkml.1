Return-Path: <linux-kernel-owner+w=401wt.eu-S935506AbXHJRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935506AbXHJRwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXHJRwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:52:12 -0400
Received: from hqemgate01.nvidia.com ([216.228.112.170]:9068 "EHLO
	HQEMGATE01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbXHJRwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:52:11 -0400
Message-ID: <46BB89C0.5070301@nvidia.com>
Date: Thu, 09 Aug 2007 17:40:16 -0400
From: Ayaz Abdulla <aabdulla@nvidia.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.2
References: <20070809214716.GA31414@kroah.com> <20070809214745.GA31425@kroah.com> <200708101626.21927.prakash@punnoor.de>
In-Reply-To: <200708101626.21927.prakash@punnoor.de>
X-NVConfidentiality: public
Content-Type: multipart/mixed;
 boundary="------------010500010102070306050207"
X-OriginalArrivalTime: 10 Aug 2007 17:50:41.0209 (UTC) FILETIME=[F7B95290:01C7DB76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010500010102070306050207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Yes, you are right. Copy and paste error. I have attached a patch which 
will fix this issue.

Thanks for catching it.
Ayaz

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>


Prakash Punnoor wrote:
> Hi,
> 
> I just noticed that PHY_OUI_VITESSE == PHY_OUI_REALTEK. Is that really 
> intentional?
> 
> 
>>diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
>>index 42ba1c0..a361dba 100644
>>--- a/drivers/net/forcedeth.c
>>+++ b/drivers/net/forcedeth.c
>>@@ -550,6 +550,8 @@ union ring_type {
>> /* PHY defines */
>> #define PHY_OUI_MARVELL	0x5043
>> #define PHY_OUI_CICADA	0x03f1
>>+#define PHY_OUI_VITESSE	0x01c1
>>+#define PHY_OUI_REALTEK	0x01c1
> 
> - 
> (°=                 =°)
> //\ Prakash Punnoor /\\
> V_/                 \_V

--------------010500010102070306050207
Content-Type: text/plain;
 name="patch-realtek-oui"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-realtek-oui"

--- old/drivers/net/forcedeth.c	2007-08-09 17:37:12.000000000 -0400
+++ new/drivers/net/forcedeth.c	2007-08-09 17:37:07.000000000 -0400
@@ -551,7 +551,7 @@
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
-#define PHY_OUI_REALTEK	0x01c1
+#define PHY_OUI_REALTEK	0x0732
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00

--------------010500010102070306050207--
