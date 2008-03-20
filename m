Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYCTTTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYCTTTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 15:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYCTTTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 15:19:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYCTTTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 15:19:40 -0400
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
From: Jon Masters <jcm@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080320191205.GA13309@elte.hu>
References: <20080320002737.918213455@polymtl.ca>
	 <20080320002835.384758480@polymtl.ca>  <20080320191205.GA13309@elte.hu>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Thu, 20 Mar 2008 15:18:25 -0400
Message-Id: <1206040705.5225.20.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 20:12 +0100, Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > There seems to be good arguments for markers to support proprierary 
> > modules. So I am throwing this one-liner in and let's see how people 
> > react. [...]
> 
> ugh, this is unbelievably stupid move technically - so a very strong 
> NACK. Allowing marker use in unfixable modules (today it's placing 
> markers into unfixable modules, tomorrow it's marker use by such 
> modules) has only one clear and predictable effect: it turns marker 
> calls into essential ABIs because when faced with any breakage in an 
> unfixable module that makes use of a marker in some kernel subsystem 
> then all the pressure is on those who _can_ fix their code - meaning the 
> kernel subsystem maintainers that use markers.

Mathieu's previous comment was that this was to help improve the quality
of such drivers. Out of interest, why do you dislike markers so much?

Jon.


