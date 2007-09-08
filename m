Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbXIHVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbXIHVSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 17:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbXIHVSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 17:18:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55806 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbXIHVSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 17:18:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Sat, 8 Sep 2007 23:29:56 +0200
User-Agent: KMail/1.9.5
Cc: "=?iso-8859-2?q?Micha=B3?= sed" <sedmich@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, htejun@gmail.com, hmh@hmh.eng.br,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <838f88840708051433k6deed4bdg8d411e79c629ca49@mail.gmail.com> <6bffcb0e0709080832o30fb21b5vcd09baa8387efcc0@mail.gmail.com>
In-Reply-To: <6bffcb0e0709080832o30fb21b5vcd09baa8387efcc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709082329.57811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 September 2007 17:32, Michal Piotrowski wrote:
> Hi,
> 
> On 05/08/2007, Micha³ sed <sedmich@gmail.com> wrote:
> > Greetings
> >
> > I'm experiencing double disk spin down issue on my HP nx6310 laptop
> > during shut down and suspend to disk. The drive is power down on "Will
> > now halt message" then turned back on and off again with the laptop
> > itself. I'm using the newest bios available F.0D, 2.6.23-rc1-mm kernel
> > along with Debian Unstable plus fixes from Sidux repository so I have
> > the updated shut down script. I have also verified on two other
> > systems [AMD/Nforce based] that the spin down issue has been resolved
> > by the Sidux update and I'm certain that this is a hp bios bug or a
> > piix kernel module problem.
> >
> 
> What is the _actual_ state of this bug? Does anyone work on this?
> 
> I see the report
> http://lkml.org/lkml/2007/8/5/214
> 
> and a very long thread
> http://lkml.org/lkml/2007/8/6/4
> 
> dmidecode stuff
> http://bugzilla.kernel.org/show_bug.cgi?id=8855
> 
> and _only_one_fix_ - for Suspend To Disc (thanks Rafael)
> http://lkml.org/lkml/2007/8/7/316

There's an updated version of that patch at
http://lkml.org/lkml/2007/8/27/392
 
> Shutdown is completely broken on HP NX6??? laptops.

It's not completely broken, it just handles disks incorrectly and we are not
sure whether or not there are any serious consequences of that.  Moreover,
it has happened for a long time now, AFAICT, so that's not a regression.

BTW, in my opinion, we don't really understand why the patch at
http://lkml.org/lkml/2007/8/27/392 actually helps and understanding that might
allow us to fix the problem in general.

Greetings,
Rafael
