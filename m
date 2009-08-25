Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZHYS7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZHYS7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZHYS7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:59:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbZHYS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:59:10 -0400
Date: Tue, 25 Aug 2009 11:57:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
In-Reply-To: <4A943290.5080606@kernel.org>
Message-ID: <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo>
 <4A943290.5080606@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Yinghai Lu wrote:
> 
> initial apic id and apic id could be different.
> 
> and we should use initial apic id to get correct phys pkg id in case BIOS set crazy apic id.

Yinghai - I think you missed Cyrills' point.  Let me repeat it:

	"cpu_has_apic bit turned off"

there's no apic. No "initial apic id". No "phys pkg id". No nothing. 

Discussions about "correct phys pkg id" are pointless.

			Linus
