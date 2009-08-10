Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZHJQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZHJQbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZHJQbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:31:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:36804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbZHJQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:31:34 -0400
Date: Mon, 10 Aug 2009 09:28:26 -0700
From: Greg KH <gregkh@suse.de>
To: "Emilio G. Cota" <cota@braap.org>
Cc: Martyn Welch <martyn.welch@gefanuc.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
Message-ID: <20090810162826.GA27912@suse.de>
References: <20090803205657.964064732@mini.kroah.org>
 <20090803210116.GC28430@kroah.com>
 <20090808232259.GA29303@braap.org>
 <20090809121715.GA3884@braap.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090809121715.GA3884@braap.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 02:17:16PM +0200, Emilio G. Cota wrote:
> (oops, just correcting Sebastien's e-mail address)
> 
> Emilio G. Cota wrote:
> > I remember we had a look at the vmelinux interface, but it really
> > was so limited that we decided to get rid of it altogether. Do you
> > really think it's worth bringing it back to life? Since it's never
> > been merged into the kernel, why don't we just get it right this time
> > and forget about it?
> > 
> > Instead of using that we implemented a heretic IOCTL-based
> > interface for user-space; at least with it you could create a
> > driver (with no interrupt support) for a device in user-space.

Why not just use the UIO interface instead of creating
yet-another-kernel/user-api?

Will that interface not work for what you want to use here?

thanks,

greg k-h
