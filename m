Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYCCGWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYCCGWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 01:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYCCGWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 01:22:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYCCGWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 01:22:40 -0500
Message-ID: <47CB96D5.3030509@zytor.com>
Date: Sun, 02 Mar 2008 22:12:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized
 integers
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <20080303023851.GF24386@parisc-linux.org> <47CB81EA.8070802@zytor.com> <20080303062007.GY27894@ZenIV.linux.org.uk>
In-Reply-To: <20080303062007.GY27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sun, Mar 02, 2008 at 08:43:22PM -0800, H. Peter Anvin wrote:
>>>> +#define S64_C(x) x ## LL
>>>> +#define U64_C(x) x ## ULL
>>> but can't we use the latter for all arches?
>>>
>> You really don't want to, as the whole point is that you want it to 
>> match what u64/s64 is defined as, in order to avoid spurious warnings.
> 
> Excuse me, in which contexts?  Where does replacement of explicitly long
> constant with explicitly long long one generate warnings on a host that has
> range(long) equal to range(long long)?

printf, for example.

	-hpa
