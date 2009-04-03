Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbZDCGw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbZDCGw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDCGwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:52:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50952 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZDCGwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:52:49 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       dhowells@redhat.com, lethal@linux-sh.org, kernel@wantstofly.org,
       matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
From: Andi Kleen <andi@firstfloor.org>
References: <20090203183426.GA14409@linux.vnet.ibm.com>
	<20090329203118.GA14005@linux.vnet.ibm.com>
	<20090402223605.GB19007@elte.hu>
	<20090402154444.b143efcf.akpm@linux-foundation.org>
Date: Fri, 03 Apr 2009 08:52:41 +0200
In-Reply-To: <20090402154444.b143efcf.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 2 Apr 2009 15:44:44 -0700")
Message-ID: <87prfukz46.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 3 Apr 2009 00:36:05 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> 
>> Andrew, what do you think?
>
> I'm really struggling to see how the 900-odd bytes saved justifies
> creating (yet another) variant of core kernel machinery.

Also it's unclear if anything special cased !SMP is worth it for the
future.  After all multi core or SMT is becoming more and more common even in
the embedded world.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
