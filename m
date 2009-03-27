Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbZC0PWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbZC0PWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZC0PWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:22:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57190 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZC0PWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:22:36 -0400
Date: Fri, 27 Mar 2009 15:22:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327152221.GA25234@srcf.ucam.org>
References: <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:08:11PM +0000, Alan Cox wrote:

> Not checking for errors is not "progress" its indiscipline aided by
> languages and tools that permit it to occur without issuing errors. It's
> why software "engineering" is at best approaching early 1950's real
> engineering practice ("hey gee we should test this stuff") and has yet to
> grow up and get anywhere into the world of real engineering and quality.

No. Not *having* to check for errors in the cases that you care about is 
progress. How much of the core kernel actually deals with kmalloc 
failures sensibly? Some things just aren't worth it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
