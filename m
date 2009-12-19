Return-Path: <linux-kernel-owner+w=401wt.eu-S1751092AbZLSJ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbZLSJ1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 04:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZLSJ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 04:27:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:48645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZLSJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 04:27:00 -0500
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com>
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Dec 2009 10:26:07 +0100
Message-ID: <1261214767.20899.697.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 23:05 +0100, Frederic Weisbecker wrote:
> +#ifndef BITS_PER_LONG
>  /* CHECKME: Not sure both always match */
>  #define BITS_PER_LONG  __WORDSIZE
> +#endif 

Why use __WORDSIZE if you're not sure?

(8*sizeof(long)) is simple and unambiguous.

