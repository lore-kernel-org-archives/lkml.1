Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZEKU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZEKU5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759288AbZEKU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:57:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564AbZEKU47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:56:59 -0400
Date: Mon, 11 May 2009 13:51:17 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 01/13] Driver Core: add nodename callbacks
Message-ID: <20090511205117.GA27815@suse.de>
References: <20090509142601.874865281@blue.kroah.org> <20090509143631.276407654@blue.kroah.org> <20090510225246.0a77b557.sfr@canb.auug.org.au> <ac3eb2510905100619j2a76409fh775f42e4a745b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510905100619j2a76409fh775f42e4a745b4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 03:19:46PM +0200, Kay Sievers wrote:
> On Sun, May 10, 2009 at 14:52, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> >> +++ b/include/linux/device.h
> >>  struct device {
> >>       struct device           *parent;
> >> +     char *(*nodename)(struct device *dev);
> >
> > Just wondering what this callback is for.  I didn't look really hard, but
> > couldn't find it used anywhere.
> 
> You are right, that seems like a left-over which did not get used, and
> should be removed from the patch.

I've now removed it, thanks Stephen for finding this.

greg k-h
