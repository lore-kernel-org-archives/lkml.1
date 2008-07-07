Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbYGGGX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbYGGGX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYGGGXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:23:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:49993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYGGGXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:23:42 -0400
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland McGrath <roland@redhat.com>
Cc: Nathan Lynch <ntl@pobox.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080707061811.19989154246@magilla.localdomain>
References: <20080703234140.GC9594@localdomain>
	 <20080704021929.5E9EF1541F5@magilla.localdomain>
	 <1215409693.8970.79.camel@pasglop>
	 <20080707061811.19989154246@magilla.localdomain>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 16:23:20 +1000
Message-Id: <1215411800.8970.91.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-06 at 23:18 -0700, Roland McGrath wrote:
> 
> Using dsocaps gives you the best of both worlds.  You can freely choose
> new strings in the kernel without the ld.so code having to know about
> them (which is not true of AT_PLATFORM, but may be true of how you are
> thinking about "strings are nice").  You do have to map all the
> possibilities that a single kernel build can produce into distinct bits.
> But, there are 32 unallocated bits to start with.  Moreover, those bit
> assignments are not part of any permanent ABI like bits in AT_* values.
> They just have to match up between this kernel build and the ld.conf.d
> file installed along with it--kernel hackers and kernel packagers have
> to coordinate, not kernel hackers and userland hackers.

I'm not sure... if ld.conf.d isn't parse of the kernel source tree then
it -will- end in tears...

Ben.


