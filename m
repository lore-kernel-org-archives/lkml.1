Return-Path: <linux-kernel-owner+w=401wt.eu-S932595AbZKDVBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbZKDVBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbZKDVBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:01:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36173 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbZKDVBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:01:01 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
Date: Wed, 04 Nov 2009 22:01:05 +0100
In-Reply-To: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1> (Christoph Lameter's message of "Wed, 4 Nov 2009 14:14:41 -0500 (EST)")
Message-ID: <87r5se80oe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:
>
> One price to pay for these improvements is the need to scan over all percpu
> counters when the actual count values are needed.

Do you have numbers how costly alloc_percpu() is? I wonder what this
does to fork() overhead.

-Andi
 

-- 
ak@linux.intel.com -- Speaking for myself only.
