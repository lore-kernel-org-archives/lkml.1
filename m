Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXFNTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXFNTZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXFNTZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:25:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXFNTZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:25:37 -0400
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132304.21984.dhazelton@enter.net>
	<ork5u7i0oi.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141014.21574.rgetz@blackfin.uclinux.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 14:46:40 -0300
In-Reply-To: <200706141014.21574.rgetz@blackfin.uclinux.org> (Robin Getz's message of "Thu\, 14 Jun 2007 10\:14\:21 -0400")
Message-ID: <or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Thu 14 Jun 2007 01:07, Alexandre Oliva pondered:

>> then maybe the small 
>> company could have been more careful about the regulations.  There are
>> various ways to prevent these changes that don't involve imposing
>> restrictions of modification on any software in the device, all the
>> way from hardware-constrained output power to hardware-verified
>> authorized configuration parameters.

> As a person pretty familiar with the hardware in these types of
> devices - this just isn't practical.

I actually left out the most obvious one: store the program in ROM.
Is that not practical?

You're claiming that adding hardware locks and chains and bolts,
implemented with help from the loader software, is simpler than just
using ROM?

Well, then, ok: do all that loader and hardware signature-checking
dancing, sign the image, store it in the machine, and throw the
signing key away.  This should be good for the highly-regulated areas
you're talking about.  And then, since you can no longer modify the
program, you don't have to let the user do that any more.  Problem
solved.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
