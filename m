Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZGRWpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZGRWpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 18:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZGRWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 18:45:23 -0400
Received: from kroah.org ([198.145.64.141]:44259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZGRWpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 18:45:22 -0400
Date: Sat, 18 Jul 2009 15:32:50 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Subject: Re: vc: create vcs(a) devices for consoles
Message-ID: <20090718223250.GB9857@kroah.com>
References: <1247931257.29760.1.camel@yio.site>
 <20090718160101.GA13346@kroah.com>
 <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 06:12:20PM +0200, Kay Sievers wrote:
> On Sat, Jul 18, 2009 at 18:01, Greg KH<greg@kroah.com> wrote:
> > On Sat, Jul 18, 2009 at 05:34:17PM +0200, Kay Sievers wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >> Subject: vc: create vcs(a) devices for consoles
> >>
> >> The buffer for the consoles are unconditionally allocated at
> >> con_init() time, which miss the creation of the vcs(a) devices.
> >>
> >> Since 2.6.30, these devices are no longer created at open()
> >> and removed on close(), but controlled by the lifetime of the
> >> buffers.
> >
> > Is this a bug in .31-rc right now?  Should this make it into the final
> > .31 release?
> 
> Yes, and in .30.
> 
> > And what caused this change, tty changes?  If so, it should go through
> > Alan Cox's tree.
> 
> This change caused it:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4995f8ef9d3aac72745e12419d7fbaa8d01b1d81

Ah, ok, I will queue it up.

thanks,

greg k-h
