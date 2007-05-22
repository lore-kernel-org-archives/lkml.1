Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXEVUUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXEVUUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbXEVUTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:19:55 -0400
Received: from [216.16.235.2] ([216.16.235.2]:41963 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbXEVUTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:19:55 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 16:17:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <m3ejl8k6e3.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
 <20070522135927.GA2098@stusta.de> <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Krzysztof Halasa wrote:

> Adrian Bunk <bunk@stusta.de> writes:
>
> >> no, i think you're thinking of the alternative ATTRIB_NORET macro.
> >> as you can read in my previous post, NORET_TYPE used to resolve to
> >> "__volatile__" for very old gcc.  so i think it's legitimately dead
> >> and can be ripped out.
> >
> > No doubt that it could be removed because it doesn't have any effect.
> >
> > But locking at the usages, it seems to have been used when people
> > thought it was what __noreturn now is, so replacing NORET_TYPE with
> > __noreturn might be a small optimization (but every NORET_TYPE should
> > be checked that it's actually correct).
>
> Actually it seems all the NORET_TYPEs are in fact (should be)
> __attribute__((noreturn)) (2.6.21):

that may be but, as i suggested earlier, that would get into guessing
what those developers were thinking, and i just didn't want to go
there.

the simple version of the patch is now in andrew's tree, and i'll
worry about the harder stuff next time.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
