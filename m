Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYFJS2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYFJS2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYFJS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:28:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38926 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314AbYFJS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:28:08 -0400
Date: Tue, 10 Jun 2008 11:28:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mike Travis <travis@sgi.com>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 02/41] cpu alloc: The allocator
In-Reply-To: <484EC25E.4070209@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0806101127520.17349@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
 <483F8AF7.9000309@cosmosbay.com> <Pine.LNX.4.64.0805292219220.12107@schroedinger.engr.sgi.com>
 <4846AD84.2090800@sgi.com> <Pine.LNX.4.64.0806101032550.17131@schroedinger.engr.sgi.com>
 <484EC25E.4070209@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Eric Dumazet wrote:

> Well, MODULE is not CONFIG_MODULES :)
> 
> If compiling an object that is going to be statically linked to kernel, MODULE
> is not defined, so we have shared objects.
> 
> When compiling a module, we cannot *yet* use .data.percpu.shared_aligned
> section, since module loader wont handle this section.
> 
> Alternative is to change modules linking for all arches to merge
> .data.percpu{*} subsections correctly, or tell module loader to take into
> account all .data.percpu sections.
> 
> AFAIK no module uses DEFINE_PER_CPU_SHARED_ALIGNED() yet...

Ahhh. Makes sense. Add a comment to explain this?

