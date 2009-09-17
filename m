Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZIQTLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZIQTLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZIQTLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:11:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:33175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZIQTLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:11:54 -0400
Date: Thu, 17 Sep 2009 21:11:38 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Scott James Remnant <scott@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
Message-ID: <20090917211138.29ff9bfd@infradead.org>
In-Reply-To: <1253213956.4718.18.camel@quest>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<20090917141303.428fe73c@lxorguk.ukuu.org.uk>
	<1253205332.4718.9.camel@quest>
	<20090917194725.355b761c@infradead.org>
	<1253213956.4718.18.camel@quest>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 19:59:16 +0100
Scott James Remnant <scott@canonical.com> wrote:

> On Thu, 2009-09-17 at 19:47 +0200, Arjan van de Ven wrote:
> 
> > > I don't really see the issue here.  If Arjan doesn't want to use
> > > devtmpfs for Moblin, he doesn't have to.
> > 
> > my biggest objection was to the use of boot time as argument.
> > That was and still is deceiving and false. There may be other
> > arguments for devfs, but I'm not going to get in the middle of
> > those. But boot time isn't it.
> > 
> Right, I don't disagree.
> 
> For some distributions devtmpfs allows them to do things without
> running udev early; we long ago restructured Ubuntu so that udev is
> one of the first things we run, therefore don't have that particular
> problem.
> 
> From my POV devtmpfs is useful because it means we can do away with
> udev entirely in certain situations, especially the installer and
> probably our initramfs when we need one too.
> 
> The "statically make /dev from /sys" tools don't help, because /dev
> needs to be kept up to date.  And udev is too heavy, or the increased
> maintenance of having a special installer udev is too annoying, etc.

hmmm I don't see our udev to be heavy in Moblin
(but that is after we do the sysfs->dev step)
