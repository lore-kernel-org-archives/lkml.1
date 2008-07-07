Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbYGGQRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbYGGQRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYGGQQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:16:29 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:34710 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYGGQQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:16:28 -0400
Date: Mon, 7 Jul 2008 11:16:13 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Roland McGrath <roland@redhat.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
Message-ID: <20080707161613.GF9594@localdomain>
References: <20080703234140.GC9594@localdomain>
 <20080704021929.5E9EF1541F5@magilla.localdomain>
 <1215409693.8970.79.camel@pasglop>
 <20080707061811.19989154246@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707061811.19989154246@magilla.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 0D0E7A72-4C40-11DD-BEA0-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> > Well, we use strings to represent the platforms already (ie, the actual
> > CPU microarchitecture). Fitting those into bits would be annoying, it
> 
> Then use dsocaps.
> 
> > makes sense to have AT_BASE_PLATFORM to be the "base" variant of
> > AT_PLATFORM.
> 
> I understand why you think so.  But let's not be too abstract.  The
> purpose of the addition is to drive ld.so's selection of libraries, yes?

That is one purpose.  But there are others (JVMs, performance tools).
dsocaps seems to be an ld.so-specific thing... or am I missing how a
"third-party" program would use it?
