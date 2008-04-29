Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYD2FAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYD2FAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYD2FAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:00:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:44388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYD2FAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:00:38 -0400
Date: Mon, 28 Apr 2008 21:58:49 -0700
From: Greg KH <gregkh@suse.de>
To: Stas Sergeev <stsp@aknet.ru>
Cc: tiwai@suse.de, Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: patch
	driver-core-warn-about-duplicate-driver-names-on-the-same-bus.patch
	added to gregkh-2.6 tree
Message-ID: <20080429045849.GA6348@suse.de>
References: <12094266793898@kroah.org> <4816A888.9000802@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4816A888.9000802@aknet.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 08:48:08AM +0400, Stas Sergeev wrote:
> Hello.
> 
> gregkh@suse.de wrote:
> > This is a note to let you know that I've just added the patch titled
> >      Subject: driver core: warn about duplicate driver names on the same bus
> > to my gregkh-2.6 tree.  Its filename is
> Thanks.
> 
> Takashi, do you think this fixes the
> pcspkr/snd-pcsp conflict sufficienly
> well? I think the Kconfig protection
> is no longer needed. For the better
> convinience the modprobe rule can be
> created that will remove one driver
> before inserting another. But this is
> optional.

No, don't rely on the driver core warning and catching code errors like
this, that's not a good idea at all.  I like the warning and your patch,
but don't assume it's always going to be there.

thanks,

greg k-h
