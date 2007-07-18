Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbXGRTmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbXGRTmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXGRTl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:41:57 -0400
Received: from waste.org ([66.93.16.53]:60571 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbXGRTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:41:57 -0400
Date: Wed, 18 Jul 2007 14:41:37 -0500
From: Matt Mackall <mpm@selenic.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718194137.GG11166@waste.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E3806.4030804@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
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
> 
> Well, how big the vmlinux file is matters if it doesn't fit in memory
> with enough time to get to the phase where it is dumping the init
> sections.  *If that is not the issue*, then axing stuff like CPUID is a
> major lose in terms of code maintainability for zero gain.

That's not the point at all.

Every byte you can shave off the compressed kernel image is another
byte you can use for userspace on your FLASH.

-- 
Mathematics is the supreme nostalgia of our time.
