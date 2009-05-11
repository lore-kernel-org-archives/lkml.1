Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZEKPc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZEKPc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZEKPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:32:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZEKPcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:32:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
Date: Mon, 11 May 2009 17:31:24 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       e1000-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <49F06EEB.9060500@gmail.com> <4A0836CA.5070709@gmail.com> <200905111724.12606.rjw@sisk.pl>
In-Reply-To: <200905111724.12606.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905111731.25043.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009, Rafael J. Wysocki wrote:
> On Monday 11 May 2009, Jiri Slaby wrote:
> > On 04/24/2009 06:09 PM, Rafael J. Wysocki wrote:
> > > My understanding is that the commit pointed to by Jiri caused a problem
> > > if the current mainline kernel was kexeced from an older kernel (2.6.27.x from
> > > openSUSE-11.1 in this particular case), because the older kernel didn't
> > > have the recent network driver fixes applied.  Is this correct?
> > 
> > Exactly!
> > 
> > > Also, I'm still interested in whether or not removig the following three lines:
> > > 
> > >         /* Check if we're already there */
> > >         if (dev->current_state == state)
> > >                 return 0;
> > > 
> > > from pci_set_power_state() in the current mainline kernel fixes the problem
> > > in the configuration where it is readily reproducible.
> > 
> > After removing those lines, the problem still persists:
> > e1000: 0000:02:01.0: e1000_probe: The EEPROM Checksum Is Not Valid
> 
> So it's more complicated than I thought.  Well ...
> 
> What if the driver in question is rmmoded before kexec?

Well, it should be the same, never mind.
