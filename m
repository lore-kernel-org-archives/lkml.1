Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbXKFJQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbXKFJQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXKFJQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:16:05 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:43393 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbXKFJQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:16:03 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] fixing usb-midi device support
Date: Tue, 6 Nov 2007 10:17:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vitaliy Ivanov <vitalivanov@gmail.com>, Jaroslav Kysela <perex@suse.cz>
References: <Pine.GSO.4.55.0710311423530.10148@helios.cs.csubak.edu> <20071105192153.2bbae10f.akpm@linux-foundation.org> <Pine.GSO.4.55.0711052029180.16561@helios.cs.csubak.edu>
In-Reply-To: <Pine.GSO.4.55.0711052029180.16561@helios.cs.csubak.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711061017.06581.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 06 November 2007 schrieb David Griffith:
> On Mon, 5 Nov 2007, Andrew Morton wrote:
> 
> > On Thu, 1 Nov 2007 10:20:24 -0700 (PDT) David Griffith <dgriffi@cs.csubak.edu> wrote:
> >
> > > On Thu, 1 Nov 2007, Vitaliy Ivanov wrote:
> >
> > Lots of cc's added.
> >
> > > > David,
> > > >
> > > > On 10/31/07, David Griffith <dgriffi@cs.csubak.edu> wrote:
> > > > >
> > > > > I have a MOTU Fastlane and an Emu Xmidi 2x2 USB midi interfaces.  The Emu
> > > > > unit works fine with current kernels.  The MOTU unit won't work with
> > > > > kernels newer than 2.6.17.
> >
> > It's a regression.
> 
> > > The oops is still present.  I was hoping that the patch I found and lost
> > > would help me understand what was going on.
> > >
> >
> > Are you able to send a copy of the oops output?
> 
> Yes.
> 
> To refresh everyone, I got this by doing "amidi -d -p virtual" in
> one xterm.  Then I started MIOS Studio
> (http://www.midibox.org/mios_studio/) and patched the internal in port to
> all available out ports including the virtual one just created.  Remove
> the MIDI interface, then quit MIOS Studio.  An oops will immediately
> occur.

You are suffering from the sysfs/usb_set_configuration() issue.
please try this patch:

http://www.mail-archive.com/git-commits-head%40vger.kernel.org/msg28576.html

	Regards
		Oliver
