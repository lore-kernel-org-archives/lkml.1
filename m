Return-Path: <linux-kernel-owner+w=401wt.eu-S1161109AbXBRIM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109AbXBRIM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161127AbXBRIM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:12:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58019 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161109AbXBRIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:12:28 -0500
Date: Sun, 18 Feb 2007 09:12:43 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] override build timestamp
Message-ID: <20070218081243.GA25618@aepfle.de>
References: <20070216215213.GA10732@aepfle.de> <Pine.LNX.4.64.0702180259210.14458@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702180259210.14458@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, Roman Zippel wrote:

> Hi,
> 
> On Fri, 16 Feb 2007, Olaf Hering wrote:
> 
> > Pass a timestamp to kbuild via an enviroment variable.
> > 
> >     TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux
> > 
> > This can be used when the kernel source is in a SCM and uname -v
> > is supposed to give the commit date and not the package build time.
> 
> Is this really necessary? I don't really see the point of this.

The package/kernel buildtime does not mean much, but the commit date
gives you a way to restore the source state for a given binary.
