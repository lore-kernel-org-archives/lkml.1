Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbYD2P07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbYD2P07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbYD2P0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:26:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46843 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765223AbYD2P0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:26:41 -0400
Date: Tue, 29 Apr 2008 08:22:49 -0700
From: Greg KH <greg@kroah.com>
To: SL Baur <steve@xemacs.org>
Cc: "gregkh@suse.de" <gregkh@suse.de>, dan.j.williams@intel.com,
       akpm@linux-foundation.org, hpa@zytor.com, htejun@gmail.com,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, lkml@rtr.ca,
       neilb@suse.de
Subject: Re: patch
	sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.pat
	ch added to gregkh-2.6 tree
Message-ID: <20080429152249.GB11329@kroah.com>
References: <1208800267.26479.3.camel@dwillia2-linux.ch.intel.com> <12094266993881@kroah.org> <ed10ee420804290048pb0070ffhaf2e9dffe6868ac5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed10ee420804290048pb0070ffhaf2e9dffe6868ac5@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:48:11AM -0700, SL Baur wrote:
> On 4/28/08, gregkh@suse.de <gregkh@suse.de> wrote:
> >
> >  This is a note to let you know that I've just added the patch titled
> >
> >      Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
> >
> >  to my gregkh-2.6 tree.  Its filename is
> >
> >      sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch
> 
> >  +       char devt_str[15];
> >  +
> >  +       if (kobj) {
> >  +               format_dev_t(devt_str, dev->devt);
> 
> This part is ugly, but is not the fault of the patch.  The ill-
> considered interface for `format_dev_t' is something that probably
> noone wants to fix.

Why not?  Patches are always welcome, it's not like that function is
used in that many different places, should be a simple change...

> Otherwise, still OK with me.
> 
> Reviewed-by: SL Baur <steve@xemacs.org>
> 
> (Is Reviewed-by not sticky?)

Yes, it is, I'll add it to my version of the patch.

thanks,

greg k-h
