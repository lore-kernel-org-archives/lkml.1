Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbXJNBOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbXJNBOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 21:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXJNBOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 21:14:44 -0400
Received: from mint.qinip.net ([62.100.30.37]:63058 "EHLO mint.qinip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbXJNBOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 21:14:43 -0400
Date: Sun, 14 Oct 2007 03:14:40 +0200
From: Arjan Opmeer <arjan@opmeer.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Message-ID: <20071014011440.GB15877@adopmeer.homeip.net>
References: <20070914000015.GA20527@adopmeer.homeip.net> <d120d5000710091301h790db3c4nc44e71551a4bc408@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710091301h790db3c4nc44e71551a4bc408@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ado@adopmeer.homeip.net
Subject: Re: First stab at Elantech touchpad driver for 2.6.22.6. Testers
	wanted!
X-SA-Exim-Version: 4.2.1 (built Tue, 21 Aug 2007 23:39:36 +0000)
X-SA-Exim-Scanned: Yes (on Ado.lan)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dmitry,

On Tue, Oct 09, 2007 at 04:01:58PM -0400, Dmitry Torokhov wrote:
> On 9/13/07, Arjan Opmeer <arjan@opmeer.net> wrote:
> >
> > This is a first stab at a Linux driver for the Elantech touchpad as
> > found on some laptops (e.g. MSI MS-1035 aka L725).
> 
> Since the touchpad supports absolute mode I'd recommend removing
> support for extended relative mode and concentrating on making
> absolute mode work so that Synaptics X driver can be used with this
> touchpad as well.

Well, from the few reports I got it seems not all Elantech touchpads are
created equal. And as we don't have any documentation on these touchpads I
really don't know whether they all support absolute mode, have the same
parameters or use the same protocol for it.

So for the time being I really would like to keep support for absolute as
well as relative mode in to make it easier for users to switch and test and
find out and report where thing go wrong.

Maybe that once we find out more about these touchpads and the possible
different version we can focus on a solution that will fit all. But let's
not do it while users are still trying whether the driver works for them at
all... :)


Arjan

