Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYLBXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYLBXJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYLBXJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:09:40 -0500
Received: from ozlabs.org ([203.10.76.45]:34098 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYLBXJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:09:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] ring-buffer: read page interface
Date: Wed, 3 Dec 2008 09:39:29 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, srostedt@redhat.com
References: <20081202203404.496794864@goodmis.org> <20081202203425.040910271@goodmis.org> <20081202133654.2dfa51cd.akpm@linux-foundation.org>
In-Reply-To: <20081202133654.2dfa51cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030939.29907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008 08:06:54 Andrew Morton wrote:
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > +	if (!local_read(&cpu_buffer->reader_page->page->commit))
>
> Rusty (I think it was Rusty) has convincingly argued that local_t is
> irredeemably busted.  I forget the details?

That was probably Christoph Lameter.  The x86 implementation needs some love, 
but the API seems reasonable.

On x86-32, the cpu_local_inc should be (as intended) turned into one insn.  
That would be possible on 64 bit once we get zero-based percpu (as will World 
Peace).

Cheers,
Rusty.
