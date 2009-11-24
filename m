Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbZKXVD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbZKXVD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbZKXVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:03:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbZKXVD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:03:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pGl3hvP1zVysaOsKyA44lMHV+R5NL+Tr6bmESAQixlDK9xQHW3RGJu7pP3lsl/G+w
	aPjxW2hPZ9S5Kpa0VRmSA==
Date: Tue, 24 Nov 2009 13:03:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Matt Mackall <mpm@selenic.com>, paulmck@linux.vnet.ibm.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259096519.4531.1809.camel@laptop>
Message-ID: <alpine.DEB.2.00.0911241302370.6593@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258709153.11284.429.camel@laptop> <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com> <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop> <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx>
  <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx>  <1259095580.4531.1788.camel@laptop> <1259096004.17871.716.camel@calx> <1259096519.4531.1809.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Peter Zijlstra wrote:

> Merge SLQB and rm mm/sl[ua]b.c include/linux/sl[ua]b.h for .33-rc1
> 

slqb still has a 5-10% performance regression compared to slab for 
benchmarks such as netperf TCP_RR on machines with high cpu counts, 
forcing that type of regression isn't acceptable.
