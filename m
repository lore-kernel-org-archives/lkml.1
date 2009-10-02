Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZJBJR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZJBJR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZJBJR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:17:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:56629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbZJBJR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:17:27 -0400
Message-ID: <4AC5C501.5010603@kernel.org>
Date: Fri, 02 Oct 2009 18:16:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
References: <20091001212521.123389189@gentwo.org> <20091001212557.773205427@gentwo.org>
In-Reply-To: <20091001212557.773205427@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 09:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cl@linux-foundation.org wrote:
> This patch introduces two things: First this_cpu_ptr and then per cpu
> atomic operations.

I'm still not quite sure about the lvalue parameter but given that
get/put_user() is already using it, I don't think my indecisiveness
warrants NACK, so...

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
