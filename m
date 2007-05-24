Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbXEXNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbXEXNKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbXEXNKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:10:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:47854 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbXEXNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:10:22 -0400
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	<20070522135927.GA2098@stusta.de>
	<Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	<20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	<m37ir0iodl.fsf@maximus.localdomain>
	<a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	<Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
	<a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 24 May 2007 15:10:20 +0200
In-Reply-To: <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com> (Satyam Sharma's message of "Wed, 23 May 2007 19:16:24 +0530")
Message-ID: <m33b1mz7sz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Satyam Sharma" <satyam.sharma@gmail.com> writes:

> Actually there's another thing :-) The __attribute__((xxx)) must go with the
> function _declarations_ (and not the implementations/definitions). I noticed
> after my previous mail that most of the double annotations are actually in
> the case of the _declarations_ of these non-returning functions, whereas
> most of the single-occurrences of NORET_TYPE were in the function
> definitions, which means your patch that simply got rid of NORET_TYPE
> actually ended up doing exactly the right thing that we wanted :-)

Only half of it. Half of right thing is (here) a bad thing.

NORET_TYPE does not do any harm.
Removing it removes pointers to attrib((noreturn)) candidates.
Simple.
-- 
Krzysztof Halasa
