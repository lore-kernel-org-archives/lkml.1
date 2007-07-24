Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXGXWpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXGXWpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXGXWpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:45:47 -0400
Received: from 1wt.eu ([62.212.114.60]:3896 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbXGXWpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:45:46 -0400
Date: Wed, 25 Jul 2007 00:45:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070724224515.GI943@1wt.eu>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E3806.4030804@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:55:50AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > 
> >> Already with these patches I can compile a zImage kernel that is 450kb
> >> large (890kb decompressed)
> > 
> > The important part is not how big the vmlinux is, but how much
> > memory is actually used after boot. 
> > 
> > I expect concentrating some of the dynamic data structures would
> > be more fruitful in fact.
> > 
> 
> Well, how big the vmlinux file is matters if it doesn't fit in memory
> with enough time to get to the phase where it is dumping the init
> sections.  *If that is not the issue*, then axing stuff like CPUID is a
> major lose in terms of code maintainability for zero gain.

Not only that, but the size of the vmlinux matters when you have limited
flash memory to put it on. Having packaged single floppy-based firewalls
for a few years, I can assure you that even one kB sometimes matters!

> 	-hpa

Regards,
Willy

