Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZHNGKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZHNGKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 02:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZHNGKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 02:10:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:58180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZHNGKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 02:10:42 -0400
Message-ID: <4A84FF9E.3050306@kernel.org>
Date: Fri, 14 Aug 2009 15:09:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Subject: Re: [PATCHSET percpu#for-next] implement and use sparse embedding
 first chunk allocator
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 14 Aug 2009 06:09:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> This patchset teaches percpu allocator how to manage very sparse
> units, vmalloc how to allocate congruent sparse vmap areas and combine
> them to extend the embedding allocator to allow embedding of sparse
> unit addresses.  This basically implements Christoph's sparse
> congruent allocator.

Exported to linux-next.

Thanks.

-- 
tejun
