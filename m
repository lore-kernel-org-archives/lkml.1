Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZC0SvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZC0SvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZC0SvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:51:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936AbZC0SvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:51:00 -0400
Date: Fri, 27 Mar 2009 11:40:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090327183214.2e73b6a3@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0903271138220.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <20090327183214.2e73b6a3@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Alan Cox wrote:
> 
> > So the fact is, "people should always use fsync" simply isn't a realistic 
> > expectation, nor is it historically accurate. 
> 
> Far too many people don't - and it is unfortunate but people should learn
> to write quality software.

You're ignoring reality.

Your definition of "quality software" is PURE SH*T.

Look at that laptop disk spinup issue. Look at the performance issue. Look 
at something as nebulous as "usability".

If adding fsync's makes software unusable (and it does), then you 
shouldn't call that "quality software".

Alan, just please face that reality, and think about it for a moment. If 
fsync() was instantaneous, this discussion wouldn't exist. But read the 
thread. We're talking 3-5s under NORMAL load, with peaks of minutes.

		Linus
