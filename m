Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbXEWNLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbXEWNLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbXEWNLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:11:15 -0400
Received: from [216.16.235.2] ([216.16.235.2]:49510 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbXEWNLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:11:14 -0400
X-Originating-Ip: 99.246.112.70
Date: Wed, 23 May 2007 09:09:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> 
 <20070522135927.GA2098@stusta.de>  <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
  <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain> 
 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain> 
 <m37ir0iodl.fsf@maximus.localdomain> <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Satyam Sharma wrote:

> On 5/23/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > "Robert P. J. Day" <rpjday@mindspring.com> writes:
> >
> > > that may be but, as i suggested earlier, that would get into
> > > guessing what those developers were thinking, and i just didn't
> > > want to go there.
> >
> > No guessing, I just checked it (though a second check wouldn't do
> > any harm).
> >
> > > the simple version of the patch is now in andrew's tree, and
> > > i'll worry about the harder stuff next time.
> >
> > The "next time" would be much harder as there would be no key for
> > searching for these functions.
>
> Krzysztof's absolutely right ... we don't want to lose the
> NORET_TYPE annotations on all these functions before we switch them
> to ATTRIB_NORET. And yes, _all_ of these NORET_TYPE's do want to be
> ATTRIB_NORET (except for those that are double-annotated, for those
> we can just get rid of the NORET_TYPE macro).

ok, i'll go back and take another look at this.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
