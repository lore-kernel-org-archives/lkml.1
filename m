Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbZC0Sgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbZC0Sgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZC0Sgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:36:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46423 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbZC0Sgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:36:37 -0400
Date: Fri, 27 Mar 2009 18:35:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327183549.610e3864@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
	<20090327171955.78662c1e@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't be silly. If you want data corruption, then you make people write 
> threaded applications. Yes, you may work for Intel now, but that doesn't 
> mean that you have to drink the insane cool-aid. Threading is HARD. Async 
> stuff is HARD. 

Which is why you do it once in a library and express it as events. The
gtk desktop already does this and the event model it provides is rather
elegant and can handle this neatly and cleanly for the user.

> But I also think that the "we write meta-data synchronously, but then the 
> actual data shows up at some random later time" is just crazy talk. That's 
> simply insane. It _guarantees_ that there will be huge windows of times 
> where data simply will be lost if something bad happens.

Agreed - apps not checking for errors is sloppy programming however given
they make errors we don't want to make it worse. I wouldn't argue with
that - for the same reason that cars are designed on the basis that their
owners are not competent to operate them ;)

