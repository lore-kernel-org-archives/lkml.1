Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXEXN1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXEXN1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXEXN1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:27:39 -0400
Received: from [216.16.235.2] ([216.16.235.2]:37121 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757258AbXEXN1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:27:38 -0400
X-Originating-Ip: 99.246.112.70
Date: Thu, 24 May 2007 09:25:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Satyam Sharma <satyam.sharma@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <m33b1mz7sz.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705240924530.5473@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
 <20070522135927.GA2098@stusta.de> <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
 <m37ir0iodl.fsf@maximus.localdomain> <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
 <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
 <m33b1mz7sz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.396, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, DRUGS_ANXIETY 0.40, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Krzysztof Halasa wrote:

> "Satyam Sharma" <satyam.sharma@gmail.com> writes:
>
> > Actually there's another thing :-) The __attribute__((xxx)) must go with the
> > function _declarations_ (and not the implementations/definitions). I noticed
> > after my previous mail that most of the double annotations are actually in
> > the case of the _declarations_ of these non-returning functions, whereas
> > most of the single-occurrences of NORET_TYPE were in the function
> > definitions, which means your patch that simply got rid of NORET_TYPE
> > actually ended up doing exactly the right thing that we wanted :-)
>
> Only half of it. Half of right thing is (here) a bad thing.
>
> NORET_TYPE does not do any harm.
> Removing it removes pointers to attrib((noreturn)) candidates.
> Simple.

everybody take a valium -- i asked andrew to drop that patch from the
mm-tree until i get the time to go back and take a closer look.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
