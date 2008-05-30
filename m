Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYE3SB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYE3SB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYE3SBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:01:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753095AbYE3SBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:01:14 -0400
Date: Fri, 30 May 2008 11:01:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 26/41] cpu alloc: Convert mib handling to cpu alloc
In-Reply-To: <483FA30F.2050900@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0805301101040.14564@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040019.799353964@sgi.com>
 <483FA30F.2050900@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Eric Dumazet wrote:

> We also can avoid the use of two arrays when CONFIG_HAVE_CPU_OPS
> since _CPU_INC() and __CPU_INC() are both interrupt safe.
> This would reduce size of mibs by 50% and complexity (no need to sum)

Right.

