Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZKIVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZKIVX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZKIVX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:23:29 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60866 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZKIVX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:23:28 -0500
Date: Mon, 9 Nov 2009 21:23:33 +0000
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Matteo Croce <technoboy85@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF886D4.1080108@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 01:17:08PM -0800, H. Peter Anvin wrote:
> On 11/09/2009 12:16 PM, Lennart Sorensen wrote:
> > 
> > The Geode LX is what is being discussed which is in fact mostly a K6 as
> > far as I understand things.  It seems to like i686 code, other than
> > apparently those NOP instructions.  I wonder if the K6 has those noop
> > instructions and if not, perhaps gcc 4.4's -march=k6-3 would be the
> > right choice.  I have always suspected the LX was really a K6-3 based
> > design (the cache sizes are a bit different, but clock speeds and
> > instruction sets seem to match).
> > 
> > The Geode NX (which no one has mentioned yet) is an Athlon derived chip.
> > 
> 
> *As far as I know* K6 didn't have NOPL, whereas K7 does.

Which would be mroe indication that the Geode LX may in fact be a K6
based CPU design.  The Geode NX is very clearly an Athlon (K7) and AMD
has never even tried to hide that.  They have never said what the LX is
based on, other than it isn't based on the GX (fortunately, that thing
was a buggy piece of crap).

> Someone who has access to these chips could run that as an experiment.

I have lots of Geode SC1200 (GX2 SoC) and Geode LX systems around.
I think I might even have a K6-2 at home in the garage come to think
of it.

-- 
Len Sorensen
