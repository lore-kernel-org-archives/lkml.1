Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZJ1EI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZJ1EI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZJ1EIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:08:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZJ1EIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:08:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qFDiYa+ueXhVcW8wr91EUDCB36NbJNO6UICj5qlNs0jOuSwtHzX1t4BlCjHfWmsDI
	FPwX/RenqqiHoRN7jGDNA==
Date: Tue, 27 Oct 2009 21:08:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091028032954.GD7744@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0910272044420.8988@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <4AE75B38.8070301@sgi.com> <alpine.DEB.2.00.0910271345400.9183@chino.kir.corp.google.com> <4AE77BF6.2040201@sgi.com> <20091028032954.GD7744@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Andi Kleen wrote:

> >> Quite the system you have there :)  What was once 760 lines has been 
> >> reduced to 24 without removing any information.
> >>
> >> This seems to be the most we can reduce this particular output since we 
> >> don't support mapping multiple pxms to a single node.
> >
> > Yes, thanks very much for the optimization.
> >
> > (And you can add my Acked-by or whatever you need.)
> 
> Looks also good to me, thanks. Also Acked-by.
> 

Thanks Andi.  I'm hoping Ingo will pick this up and not have a problem 
with the use of NUMA_NO_NODE vs. NID_INVAL since there's a patch pending 
in -mm that removes the former and this saves a Linus build error when he 
pushes for 2.6.33 (and they are both defined the same anyway).
