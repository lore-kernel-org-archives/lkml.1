Return-Path: <linux-kernel-owner+w=401wt.eu-S2992756AbXCBXfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992756AbXCBXfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992760AbXCBXfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:35:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:58615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992756AbXCBXfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:35:06 -0500
Date: Fri, 2 Mar 2007 15:34:14 -0800
From: Greg KH <greg@kroah.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH,RFC] pci: do not mark exported functions as __devinit
Message-ID: <20070302233414.GA15038@kroah.com>
References: <20070227092702.GA21337@uranus.ravnborg.org> <20070302204752.GA24716@kroah.com> <20070302230214.GC22555@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302230214.GC22555@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 12:02:14AM +0100, Sam Ravnborg wrote:
> > 
> > Yes, we allow them to be exported globally, as other init code might
> > need to call them, like these functions.
> > 
> > So yes, I think we need to find a way to fix the warning tools, as the
> > code is correct here.
> 
> This was the patch that I made to ignore these.
> It is on top of other pending changes to modpost so it will not
> apply.
> I had to check for _ksymtab* because we have various
> section names for ksymtab. (_gpl, _future etc.)

Looks good to me.  Thanks for fixing all of these warnings.

greg k-h
