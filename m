Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZHGBK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZHGBK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZHGBK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:10:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:31663 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZHGBK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KWhW+4aqEmorL4P/1BwfTpcsKkpTjTVOvG13r+t/2llf0acXxyPPye5AhOQbskbuK8
         +HbSMAn9RV3dv/o5lIIK79oWIFhaIrnUDV6bVwfXvHok0ACXrH6aI1jSM0JIsu5akC++
         Ab4QrwCPfYpS45/dV2P5n8xcdYuT5CjyFfSjM=
Date: Fri, 7 Aug 2009 09:10:51 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-ID: <20090807011051.GA3597@darkstar>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 12:33:06AM -0700, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-08-06-00-30 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.31-rc5:
> 

Hi, andrew

Following a fix for the build warning about unused variable.
---

Fix build warning about the unused variable in char_dev.c:267

Remove the unused char *s

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
--
fs/char_dev.c |    1 -
1 file changed, 1 deletion(-)

--- linux-2.6.30.orig/fs/char_dev.c	2009-08-05 14:04:59.000000000 +0800
+++ linux-2.6.30/fs/char_dev.c	2009-08-06 20:48:24.000000000 +0800
@@ -264,7 +264,6 @@ int register_chrdev(unsigned int major, 
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
-	char *s;
 	int err = -ENOMEM;
 
 	cd = __register_chrdev_region(major, 0, 256, name);
