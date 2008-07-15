Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYGOW6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYGOW6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYGOW5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:57:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYGOW5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:57:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Avuton Olrich" <avuton@gmail.com>
Subject: Re: s2disk: system powers up again after power off
Date: Wed, 16 Jul 2008 00:59:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Martin Michlmayr" <tbm@cyrius.com>, linux-kernel@vger.kernel.org
References: <20080715124733.GA4111@deprecation.cyrius.com> <200807152224.19559.rjw@sisk.pl> <3aa654a40807151548t485ea8e6k1d7e261277c1c5aa@mail.gmail.com>
In-Reply-To: <3aa654a40807151548t485ea8e6k1d7e261277c1c5aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160059.54886.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of July 2008, Avuton Olrich wrote:
> On Tue, Jul 15, 2008 at 1:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, 15 of July 2008, Avuton Olrich wrote:
> >> On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
> >> > When I use s2disk to suspend my HP 2510p notebook, it writes
> >> > everything to disk, and powers off... but after 2-3 seconds it often
> >> > powers on again.  This doesn't happen all the time but quite
> >> > frequently (definitely in the majority of cases).
> >> >
> >> > I believe I've never seen this when I use "halt" to power off the
> >> > machine (but I don't use halt very often).
> >> >
> >> > Any idea?
> >>
> >> Ugh, this happens here too, this started occuring before 2.6.25 but
> >> every time I try to bisect it takes hours and I end up screwing up
> >> somewhere along the way, so I haven't had time to bisect this
> >> correctly.
> >
> > Please try to put "shutdown method = shutdown" into the s2disk's configuration
> > file and see what happens in that case.
> 
> Anything a little less fancy? I use pm-hibernate, or gnome's Power
> Manager to hibernate; I don't even have s2disk installed, sorry I
> should have mentioned that.

Martin mentioned s2disk in his original post.  Never mind.

Please try to do "echo shutdown > /sys/power/disk" before hibernation and
see what happens.

Thanks,
Rafael
