Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbZGIXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbZGIXU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZGIXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:20:18 -0400
Received: from kroah.org ([198.145.64.141]:54271 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZGIXUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:20:17 -0400
Date: Thu, 9 Jul 2009 16:19:56 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: linux-next: manual merge of the ttydev tree with the
 usb.current tree
Message-ID: <20090709231956.GA1033@kroah.com>
References: <20090709130430.090863dd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709130430.090863dd.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 01:04:30PM +1000, Stephen Rothwell wrote:
> Hi Alan,
> 
> Today's linux-next merge of the ttydev tree got conflicts in
> drivers/usb/serial/generic.c and include/linux/usb/serial.h between commit
> d8298d029cdd5d944c3d8369d2862de94d12ae4b ("USB: serial: regression fix to
> move sysrq from hot path") from the usb.current tree and commit
> cf8456fe1aaed1776bf4c26c18adef76e472b9fa ("tty-usb-fix-perf-regression")
> from the ttydev tree.  Also between commit
> a2170a444ef9a89a7ec9acc72d79e5db433effc4 ("USB: serial: optimize sysrq
> function calls") from the usb.current tree and commit
> bfce6b042a47c9cdd55c7cd231e58710ec1fa4e1 ("tty-usb-fix-kref-leak") from
> the ttydev tree.
> 
> The first two commits above seem to be trying to do the same thing (or
> similar) so I have used the ttydev version for now.
> 
> I fixed them up (see below) and can carry the fixes as necessary.

Thanks for the fix, I don't know what happened in the tty tree, I've not
touched the USB tree for a week or so now...

thanks,

greg k-h
