Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXGPCys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXGPCys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 22:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbXGPCyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 22:54:39 -0400
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:28729 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759234AbXGPCyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 22:54:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cdz5sJPZXQzfwqd0AH/R+LfZR8ZYNjalYEXnFMYtumJdVeJtT4ejIz82HXN6tQENQSclTVI2z4pPWxDOA/io1aHxMFhf+sXW4ejEG4/75Tli6a/HR5HGu+8CquPqKUoEWjcZpDaR+D1fAtj9HrKzWwGotQc21OAXCsej7FHnD5c=  ;
X-YMail-OSG: w2xaeWgVM1lnj3hMPCbAgYW6KYJhDmxlXh7iQxyps32hm91lq7Uw84h8acZ812fl.MLDhbSDKg--
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] minimal fixes for drivers/usb/gadget/m66592-udc.c
Date: Sun, 15 Jul 2007 19:54:36 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
References: <200707151607.20275.david-b@pacbell.net> <200707151618.10688.david-b@pacbell.net> <20070715232410.GH21668@ftp.linux.org.uk>
In-Reply-To: <20070715232410.GH21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151954.36583.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2007, Al Viro wrote:
> On Sun, Jul 15, 2007 at 04:18:10PM -0700, David Brownell wrote:
> > Re the leaks, in probe() request_irq() isn't cleaned up ... but it
> > looked to me like the rest of the allocations did get cleaned up
> > afer probe() errors.  But remove() does indeed leak the memory you
> > highlighted.
> 
> Why not make ep0_buf a 16bit field in that struct?

Ask the driver author.  :)

That should work, given proper byteswapping.  It's only
used to transmit certain results.

- Dave
 


