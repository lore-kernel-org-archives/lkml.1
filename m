Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYHGQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYHGQOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYHGQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:14:14 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50020 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYHGQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:14:14 -0400
Message-ID: <1913.69.2.248.210.1218124373.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080807160702.GF24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <Pine.LNX.4.64.0808051140150.6309@anakin>
    <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
    <200808060133.10457.nickpiggin@yahoo.com.au>
    <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>
    <20080806185719.GE24801@one.firstfloor.org>
    <37747.166.70.238.45.1218113134.squirrel@webmail.wolfmountaingroup.com>
    <20080807160702.GF24801@one.firstfloor.org>
Date: Thu, 7 Aug 2008 09:52:53 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: jmerkey@wolfmountaingroup.com, "Andi Kleen" <andi@firstfloor.org>,
       "Jason Wessel" <jason.wessel@windriver.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Also, whoever wrote "/Documentation/volatiles_are_evil" must not have
>> worked with the busted-ass GNU compiler that optimizes away global
>> variables and busts SMP dependent code.  I am not going to remove the
>
> The Linux way to handle this is to use gcc memory barriers.
> mb()/barrier()/wmb()/rmb()/smp_rmb()/smp_wmb() etc.
> Normally everything that volatile can do can be expressed by them.
>
> On x86 such a memory barrier tells gcc that memory might
> have been clobbered and needs to be flushed and also prevents the compiler
> from reordering memory accesses. On other architectures it also forces
> ordering
> on the CPU level, although that's not needed on x86 (except
> in some special situations like using write-combining)
>
> See Documentation/memory-barriers.txt
>
> -Andi
>
>

Andi,

I'll instrument this as described in the documentation you referenced and
remove the volatile declarations.  If this passes testing, I will repost
with these corections.

Jeff




