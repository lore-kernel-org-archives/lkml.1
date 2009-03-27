Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZC0TOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZC0TOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZC0TOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:14:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37687 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754505AbZC0TOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:14:40 -0400
Date: Fri, 27 Mar 2009 19:14:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327191426.3d478b6b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327190339.GW6239@mit.edu>
References: <20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
	<20090327171955.78662c1e@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
	<20090327190339.GW6239@mit.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Agreed, we need a middle ground.  We need a transition path that
> recognizes that ext3 won't be the dominant filesystem for Linux in
> perpetuity, and that ext3's data=ordered semantics will someday no
> longer be a major factor in application design.  fbarrier() semantics
> might be one approach; there may be others.  It's something we need to
> figure out.

Would making close imply fbarrier() rather than fsync() work for this ?
That would give people the ordering they want even if they are less
careful but wouldn't give the media error cases - which are less
interesting.

Alan
