Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZLXAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZLXAv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZLXAv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:51:56 -0500
Received: from kroah.org ([198.145.64.141]:34112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZLXAvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:51:55 -0500
Date: Wed, 23 Dec 2009 16:51:27 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: linux-next: usb tree build warning
Message-ID: <20091224005127.GA14997@kroah.com>
References: <20091224110109.37ac11c9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224110109.37ac11c9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 11:01:09AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/usb/core/sysfs.c: In function 'set_reset_quirk':
> drivers/usb/core/sysfs.c:201: warning: unused variable 'value'
> 
> Introduced by commit 9bc2b949ea002c26fafa8c8aa82595ff56075d4f ("USB:
> Export USB_QUIRK_RESET_MORPHS through sysfs").

Thanks, I have a follow-up patch in my queue that fixes this.  I'll
merge it together.

greg k-h
