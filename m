Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0CJLfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:35:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:60260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab0CJLfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:35:43 -0500
Subject: Re: [PATCH 2/2] percpu,module: implement and use
 is_kernel/module_percpu_address()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4B976D22.1070404@kernel.org>
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>
	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>
	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org>
	 <1268133942.4162.2.camel@twins> <4B963441.40000@kernel.org>
	 <4B976CBA.3070305@kernel.org>  <4B976D22.1070404@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Mar 2010 11:42:27 +0100
Message-ID: <1268217747.7487.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 18:57 +0900, Tejun Heo wrote:
> lockdep has custom code to check whether a pointer belongs to static
> percpu area which is somewhat broken.  Implement proper
> is_kernel/module_percpu_address() and replace the custom code.
> 
> On UP, percpu variables are regular static variables and can't be
> distinguished from them.  Always return %false on UP.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>

Looks good to me, thanks Tejun!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
