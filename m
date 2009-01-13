Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZAMSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZAMSmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZAMSmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:42:10 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:37091 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZAMSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:42:09 -0500
Date: Tue, 13 Jan 2009 10:42:02 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113184202.GB8075@localdomain>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins> <20090113123317.GA29926@elte.hu> <20090113181311.GA8075@localdomain> <20090113183420.GB10065@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113183420.GB10065@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 07:34:20PM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> On Tue, Jan 13, 2009 at 01:33:17PM +0100, Ingo Molnar wrote:
>> >
>> >
>> >VSMP is a clustering solution (default-disabled)
>> 
>> Small correction :)
>> Well, it is a virtualization solution creating single VM across multiple
>> systems.  Since it is shared memory, we would rather refer to it as SMP or
>> Virtual SMP rather than a clustering solution.
>
>You do have hardware help too to do efficient cross-node memory traffic, 
>dont you?
>

Of course.  A fast backplane interconnect.
