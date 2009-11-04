Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZKDLGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZKDLGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbZKDLGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:06:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbZKDLGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:06:11 -0500
Date: Wed, 4 Nov 2009 12:06:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: support static build
Message-ID: <20091104110604.GE13194@elte.hu>
References: <20091029152002.GA5406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029152002.GA5406@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> This makes it possible to build perf statically, by performing make 
> LDFLAGS=-static
>
> Since static libraries are only searched in the order they are 
> specified, move library list from LDFLAGS to EXTLIBS, so that they are 
> put at the end of linker command line.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Changes in v2: updated to latest tip.

The Makefile changed again so your v2 patch is conflicting too - mind 
updating it to latest -tip?

Thanks,

	Ingo
