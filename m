Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbYCCExb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbYCCExb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761939AbYCCExS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:53:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYCCExR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:53:17 -0500
Message-ID: <47CB8379.5050203@zytor.com>
Date: Sun, 02 Mar 2008 20:50:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized
 integers
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org> <200803022014.11535.david-b@pacbell.net>
In-Reply-To: <200803022014.11535.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Sunday 02 March 2008, Segher Boessenkool wrote:
> 
>> Do these new macros really buy anything over just writing LL in the
>> few places that 64-bit constants are used?
> 
> The original workaround was to make the offending *SEC_TO_HZ_ADJ32
> constants use "ULL" suffixes.  Certainly making the Perl script emit
> those would be less intrusive.
> 

"Less intrusive" in the sense of smaller line count for this particular 
patch, perhaps, but it makes it less obvious when reading the code 
what's going on (a size override in an entirely different file). 
Additionally, I'm hoping these kind of things can be used elsewhere; the 
C99 <inttypes.h> facilities are really quite nice once you get over the 
rather ugly look of them, and I for one definitely miss having access to 
the in the kernel.

	-hpa
