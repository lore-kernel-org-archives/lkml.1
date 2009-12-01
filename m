Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLACH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLACH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 21:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZLACH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 21:07:26 -0500
Received: from ozlabs.org ([203.10.76.45]:47521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZLACH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 21:07:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] staging: fix a silly typo
Date: Tue, 1 Dec 2009 12:37:29 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20091130132432.27394.48685.stgit@localhost.localdomain> <20091130163937.092f10e9@lxorguk.ukuu.org.uk> <20091130165918.GA29035@kroah.com>
In-Reply-To: <20091130165918.GA29035@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011237.30095.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 03:29:18 am Greg KH wrote:
> On Mon, Nov 30, 2009 at 04:39:37PM +0000, Alan Cox wrote:
> > Well given Rusty has vanished can you apply it to staging and rusty can
> > fix his tree up when he returns, assuming patch doesn't fix it for him.
> 
> The patch does not apply to my tree at all, the problem is caused by
> stuff done only in Rusty's tree.  He has changed the code here to be
> broken, not me, so there's really nothing I can do about it.
> 
> Stephen could apply it to linux-next though.

I missed linux-next for today, but sfr offered to apply it manually:

From:	Alan Cox <alan@linux.intel.com>
Subject: [PATCH] staging: fix a silly typo

(Resend #3)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/rtl8187se/r8180_core.c  |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 5a6cd60..d74bf70 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -79,7 +79,7 @@ MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index e24815f..0a052ea 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -142,7 +142,7 @@ static int channels = 0x3fff;
 
 
 
-module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
+module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
 //module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
 module_param(hwwep,int, S_IRUGO|S_IWUSR);
 module_param(channels,int, S_IRUGO|S_IWUSR);

