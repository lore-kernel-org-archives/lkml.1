Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYJ3Qkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYJ3Qkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYJ3Qkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:40:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:33919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbYJ3Qkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:40:40 -0400
Date: Thu, 30 Oct 2008 09:15:31 -0700
From: Greg KH <gregkh@suse.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbtmc: Fix type conflict
Message-ID: <20081030161531.GA13895@suse.de>
References: <Pine.LNX.4.64.0810301409480.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810301409480.7072@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 02:10:33PM +0200, Ilpo Järvinen wrote:
> 
> While making the other change, I noticed this:
> 
>   CC      drivers/usb/class/usbtmc.o
> drivers/usb/class/usbtmc.c: In function 'usbtmc_ioctl_abort_bulk_in':
> drivers/usb/class/usbtmc.c:164: warning: comparison is always false due to
> limited range of data type

I just sent a patch to Linus that did exactly this :)

thanks,

greg k-h
