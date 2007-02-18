Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbXBRQYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbXBRQYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXBRQYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:24:48 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:58934 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbXBRQYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:24:45 -0500
Date: Sun, 18 Feb 2007 17:24:36 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Olaf Hering <olaf@aepfle.de>
cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] override build timestamp
In-Reply-To: <20070218081243.GA25618@aepfle.de>
Message-ID: <Pine.LNX.4.64.0702181715570.14457@scrub.home>
References: <20070216215213.GA10732@aepfle.de> <Pine.LNX.4.64.0702180259210.14458@scrub.home>
 <20070218081243.GA25618@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 18 Feb 2007, Olaf Hering wrote:

> > On Fri, 16 Feb 2007, Olaf Hering wrote:
> > 
> > > Pass a timestamp to kbuild via an enviroment variable.
> > > 
> > >     TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux
> > > 
> > > This can be used when the kernel source is in a SCM and uname -v
> > > is supposed to give the commit date and not the package build time.
> > 
> > Is this really necessary? I don't really see the point of this.
> 
> The package/kernel buildtime does not mean much, but the commit date
> gives you a way to restore the source state for a given binary.

This information could also be added to the version string like 
CONFIG_LOCALVERSION_AUTO does. OTOH rather than abusing the build date 
(which may not mean much, but it nevertheless has a meaning), I'd rather 
add the possibility to add extra information.

bye, ROman
