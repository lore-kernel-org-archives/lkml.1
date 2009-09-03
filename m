Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZICVMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZICVMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbZICVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:12:05 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:60909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932242AbZICVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:12:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, rth@redhat.com
Subject: Re: [PATCH 0/4] RFC: jump label - (tracepoint optimizations)
In-Reply-To: Ingo Molnar's message of  Thursday, 3 September 2009 23:01:39 +0200 <20090903210139.GA25581@elte.hu>
References: <cover.1252007851.git.jbaron@redhat.com>
	<20090903210139.GA25581@elte.hu>
X-Shopping-List: (1) Translucent miscreants
   (2) Arab-Israeli Antiperspirant compass cancer
   (3) Satirical obsession bracelets
   (4) Inorganic finger baskets
Message-Id: <20090903211142.8490C47C94@magilla.sf.frob.com>
Date: Thu,  3 Sep 2009 14:11:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks really interesting and desired. Once GCC adds this (or an 
> equivalent) feature, i'd love to have your optimization in the 
> kernel.

We expect it will be in gcc 4.5 and backported to Fedora's 4.4 pretty soon.
But it's not finalized yet, so we are only doing proof-of-concept so far.

> Basically everything that is optional and touches some very hot 
> codepath would be eligible - not just tracepoints.

Sure.  Any place you have a load+conditional-jump where that is too costly,
we can make it a nop that costs a only cycle or so.  We probably want to
think a little harder about the nicest macro setup we can do to make
employing this trivial in the source.


Thanks,
Roland
