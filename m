Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZC0Sdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZC0Sdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZC0Sdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:33:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47225 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754295AbZC0Sdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:33:39 -0400
Date: Fri, 27 Mar 2009 18:32:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327183214.2e73b6a3@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
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
	<alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> more common either. If you have a desktop app that uses fsync(), that 
> application is DEAD IN THE WATER if people are doing anything else on the 
> machine. Those multi-second pauses aren't going to make people happy.

We added threading about ten years ago.

> So the fact is, "people should always use fsync" simply isn't a realistic 
> expectation, nor is it historically accurate. 

Far too many people don't - and it is unfortunate but people should learn
to write quality software.
> 
> Alternatives should be looked at. For desktop apps, the best alternatives 
> are likely simply stronger default consistency guarantees. Exactly the 
> "we don't guarantee that your data hits the disk, but we do guarantee that 
> if you renamed on top of another file, you'll not have lost _both_ 
> contents".

Rename is a really nasty case and the standards don't help at all here so
I agree entirely. There *isn't* a way to write a correct portable
application that achieves that guarantee without the kernel making it for
you.
