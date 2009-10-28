Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZJ1VGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZJ1VGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZJ1VGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:06:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZJ1VGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:06:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CmHMG3/7ZYc6eEQ4M40xY7lDE9zaJYCx17QliT6hJumBYgF2e9X8yVJYKfPfF+oMP
	7m9xq9xrTghiSFUWwvqmg==
Date: Wed, 28 Oct 2009 14:06:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <4AE8B197.8000606@sgi.com>
Message-ID: <alpine.DEB.2.00.0910281405450.27638@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <4AE8792F.8070200@sgi.com>
 <alpine.DEB.2.00.0910281348590.24785@chino.kir.corp.google.com> <4AE8B197.8000606@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Mike Travis wrote:

> Your latest patch tested:
> 
> [    0.000000] SRAT: PXM 0 -> APIC {0-7,16-23} -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC {32-39,48-55} -> Node 1
> [    0.000000] SRAT: PXM 2 -> APIC {64-71,80-87} -> Node 2
> [    0.000000] SRAT: PXM 3 -> APIC {96-103,112-119} -> Node 3
> [    0.000000] SRAT: PXM 4 -> APIC {128-135,144-151} -> Node 4
> [    0.000000] SRAT: PXM 5 -> APIC {160-167,176-183} -> Node 5
> [    0.000000] SRAT: PXM 6 -> APIC {192-199,208-215} -> Node 6
> [    0.000000] SRAT: PXM 7 -> APIC {224-231,240-247} -> Node 7
> [    0.000000] SRAT: PXM 8 -> APIC {256-263,272-279} -> Node 8
> [    0.000000] SRAT: PXM 9 -> APIC {288-295,304-311} -> Node 9
> [    0.000000] SRAT: PXM 10 -> APIC {320-327,336-343} -> Node 10
> [    0.000000] SRAT: PXM 11 -> APIC {352-359,368-375} -> Node 11
> [    0.000000] SRAT: PXM 12 -> APIC {384-391,400-407} -> Node 12
> [    0.000000] SRAT: PXM 13 -> APIC {416-423,432-439} -> Node 13
> [    0.000000] SRAT: PXM 14 -> APIC {448-455,464-471} -> Node 14
> [    0.000000] SRAT: PXM 15 -> APIC {480-487,496-503} -> Node 15
> [    0.000000] SRAT: PXM 16 -> APIC {512-519,528-535} -> Node 16
> [    0.000000] SRAT: PXM 17 -> APIC {544-551,560-567} -> Node 17
> [    0.000000] SRAT: PXM 18 -> APIC {576-583,592-599} -> Node 18
> [    0.000000] SRAT: PXM 19 -> APIC {608-615,624-631} -> Node 19
> [    0.000000] SRAT: PXM 20 -> APIC {640-647,656-663} -> Node 20
> [    0.000000] SRAT: PXM 21 -> APIC {672-679,688-695} -> Node 21
> [    0.000000] SRAT: PXM 22 -> APIC {704-711,720-727} -> Node 22
> [    0.000000] SRAT: PXM 23 -> APIC {736-743,752-759} -> Node 23
> [    0.000000] SRAT: PXM 24 -> APIC {768-775,784-791} -> Node 24
> [    0.000000] SRAT: PXM 25 -> APIC {800-807,816-823} -> Node 25
> [    0.000000] SRAT: PXM 26 -> APIC {832-839,848-855} -> Node 26
> [    0.000000] SRAT: PXM 27 -> APIC {864-871,880-887} -> Node 27
> [    0.000000] SRAT: PXM 28 -> APIC {896-903,912-919} -> Node 28
> [    0.000000] SRAT: PXM 29 -> APIC {928-935,944-951} -> Node 29
> [    0.000000] SRAT: PXM 30 -> APIC {960-967,976-983} -> Node 30
> [    0.000000] SRAT: PXM 31 -> APIC {992-999,1008-1015} -> Node 31
> [    0.000000] SRAT: PXM 32 -> APIC {1024-1031,1040-1047} -> Node 32
> [    0.000000] SRAT: PXM 33 -> APIC {1056-1063,1072-1079} -> Node 33
> [    0.000000] SRAT: PXM 34 -> APIC {1088-1095,1104-1111} -> Node 34
> [    0.000000] SRAT: PXM 35 -> APIC {1120-1127,1136-1143} -> Node 35
> [    0.000000] SRAT: PXM 36 -> APIC {1152-1159,1168-1175} -> Node 36
> [    0.000000] SRAT: PXM 37 -> APIC {1184-1191,1200-1207} -> Node 37
> [    0.000000] SRAT: PXM 38 -> APIC {1216-1223,1232-1239} -> Node 38
> [    0.000000] SRAT: PXM 39 -> APIC {1248-1255,1264-1271} -> Node 39                                                                                             

Looks good, 1272 lines reduced to 40.
