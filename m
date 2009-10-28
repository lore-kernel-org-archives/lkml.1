Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZJ1EJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZJ1EJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZJ1EJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:09:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1864 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbZJ1EJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:09:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lw/ojzyiY0tZfLshnZHomkFe1GxOU9qhgNKEzIg4BJwuLe7vte9DHGXksbpBoAkHi
	1viUMwfAr8Hw08jWIVJFA==
Date: Tue, 27 Oct 2009 21:08:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <4AE7C057.7030605@kernel.org>
Message-ID: <alpine.DEB.2.00.0910272103080.8988@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <4AE75B38.8070301@sgi.com> <alpine.DEB.2.00.0910271345400.9183@chino.kir.corp.google.com> <4AE7C057.7030605@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Yinghai Lu wrote:

> can you change the apic to hex print?
> 

That would be an extension made on top of my patch (which may be difficult 
without adding an additional library function to be used in this case 
since it relies on bitmap_scnlistprintf()).  It's been printed as an 
unsigned int for well over four years so I don't see any specific urgency, 
anyway.
