Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbYCFORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbYCFORT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbYCFORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:17:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYCFORF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:17:05 -0500
Message-ID: <47CFFC64.7040703@redhat.com>
Date: Thu, 06 Mar 2008 14:15:00 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, Paolo Bonzini <bonzini@gnu.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Lattner <clattner@apple.com>,
       Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
   flag
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org>
In-Reply-To: <20080306141221.GC5236@dspnet.fr.eu.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Thu, Mar 06, 2008 at 03:03:15PM +0100, Paolo Bonzini wrote:
>> Olivier Galibert wrote:
>>> On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
>>>> It's a kernel bug, and it needs to be fixed.
>>> I'm not convinced.  It's been that way for 15 years, it's that way in
>>> the BSD kernels, at that point it's a feature.  The bug is in the
>>> documentation, nowhere else.  And in gcc for blindly trusting the
>>> documentation.
>> No, the bug *in the kernel* was already present (if you had a signal 
>> raised during a call to memmove).  It's just more visible with GCC 4.3.
> 
> I'm curious, since when paper documentation became the Truth and
> reality became a bug?

Isn't that the definition of a bug?  That a program does not meet
its specification?

Andrew.

