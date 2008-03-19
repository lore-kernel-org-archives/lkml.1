Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbYCSTZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbYCSTZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYCSTYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:24:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYCSTYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:16 -0400
Message-ID: <47E112C7.8020406@zytor.com>
Date: Wed, 19 Mar 2008 06:19:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Chuck Ebbert <cebbert@redhat.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com> <47DAE909.20006@redhat.com> <47DE44F6.76E4.0078.0@novell.com>
In-Reply-To: <47DE44F6.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> 
> That's not very desirable: For one part, because there are uses of
> bitops on arrays of ints (and casting these up isn't fully correct on
> x86-64 because of the same reason that using the bitops on char
> arrays isn't correct (see the other response I sent to Jeremy's reply),
> but also because operating on longs requires REX prefixes n x86-64,
> hence making the code bigger for no good reason.
> 

It might be worthwhile to find out if 64-bit bitops are faster.

Bitops are normally defined only on longs, but since x86 is a 
littleendian architecture we sometimes fudge that in arch-specific code.

	-hpa
