Return-Path: <linux-kernel-owner+w=401wt.eu-S1762515AbZJOJL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762515AbZJOJL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZJOJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:11:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZJOJL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:11:27 -0400
Message-ID: <4AD6E6F2.9060109@kernel.org>
Date: Thu, 15 Oct 2009 18:10:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 01/16] vmalloc: fix use of non-existent percpu variable
 in put_cpu_var()
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-2-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141105360.26476@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141105360.26476@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:10:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> This looks like a candidate for 2.6.32.

Yeah, this could go to 2.6.32 too but it's only exposed by percpu
changes in percpu#for-next, so putting this together with related
percpu changes wouldn't be too bad either.  Does anyone feel strong
about this going in for 2.6.32?

Thanks.

-- 
tejun
