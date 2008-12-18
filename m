Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYLRWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYLRWRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYLRWRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:17:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbYLRWRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:17:00 -0500
Date: Thu, 18 Dec 2008 14:16:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Hollis Blanchard <hollisb@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Define smp_call_function_many for UP
In-Reply-To: <200812190840.13995.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0812181415480.14014@localhost.localdomain>
References: <20081208160945.7535A25006E@cleopatra.tlv.redhat.com> <1229014284.26586.9.camel@localhost.localdomain> <200812151904.36554.rusty@rustcorp.com.au> <200812190840.13995.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Dec 2008, Rusty Russell wrote:
>
> Linus, please apply.  Otherwise those using it in transition patches (eg. kvm)
> can't compile with CONFIG_SMP=n:

Umm. I already applied this a long time ago. It's commit 
d2ff911882b6bc693d86ca9566daac70aacbb2b3

		Linus
