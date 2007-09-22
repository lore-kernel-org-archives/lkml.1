Return-Path: <linux-kernel-owner+w=401wt.eu-S1762707AbXIVKeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707AbXIVKeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXIVKeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:34:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbXIVKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:34:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: clockevents: fix resume logic
Date: Sat, 22 Sep 2007 12:47:00 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200707220159.l6M1xBgH001236@hera.kernel.org> <20070917183737.GB5966@ucw.cz> <1190451047.4035.29.camel@chaos>
In-Reply-To: <1190451047.4035.29.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709221247.01820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 September 2007 10:50, Thomas Gleixner wrote:
> On Mon, 2007-09-17 at 18:37 +0000, Pavel Machek wrote:
> > > That's a bit tricky because hitting the keyboard is what unsticks things. 
> > > And the video is black after resume-from-RAM (has always been thus) and we
> > 
> > Ok, can we try to fix the video issue for you? That should make the
> > development easier... I assume you tried s2ram from suspend.sf.net,
> > and no combination of switches helped?
> 
> I have the same issue. Blank screen after suspend to ram. Hibernate
> works.
> 
> Do you have a debug patch or something ?

IIRC, Andrew said that the X server could restore the graphics after a resume
from RAM on his Vaio.

Greetings,
Rafael
