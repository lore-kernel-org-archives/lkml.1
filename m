Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZBYGkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZBYGkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZBYGkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:40:37 -0500
Received: from ozlabs.org ([203.10.76.45]:59362 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZBYGkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:40:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk allocation
Date: Wed, 25 Feb 2009 17:10:26 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu>
In-Reply-To: <20090224211659.GA3687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902251710.27205.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 07:46:59 Ingo Molnar wrote:
>  kernel/trace/trace_functions_graph.c: In function ‘graph_trace_close’:
>  kernel/trace/trace_functions_graph.c:836: error: implicit declaration of function ‘percpu_free’
> 
> that's free_percpu() now, right?
> 
> Btw., why was this rename done? We generally standardize on 
> hierarchical names, going from the more general to the more 
> specific names, left to right.

Agreed, but we had both, doing identical things, and free_percpu outnumbered
percpu_free by a significant factor (about 40 to 5 IIRC).

Simple pragmatism, and it matches alloc_percpu.
Rusty.
