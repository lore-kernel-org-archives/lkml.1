Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZCYA7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZCYA7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCYA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:59:26 -0400
Received: from ozlabs.org ([203.10.76.45]:38787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZCYA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:59:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Correct behaviour of irq affinity?
Date: Wed, 25 Mar 2009 11:29:19 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org> <200903251103.10249.rusty@rustcorp.com.au>
In-Reply-To: <200903251103.10249.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251129.19490.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 11:03:08 Rusty Russell wrote:
> On Tuesday 24 March 2009 23:09:37 Eric W. Biederman wrote:
> > cpu_mask_to_apic_id do not take cpu_online_map into account and should
> > probably be fixed.  flat_cpu_mask_to_apicid was the one I could find.
> 
> Also the numaq apic.h.  I'll do an audit and send a patch.

Actually, numaq is just weird, so I'll assume it's correct.  I couldn't
find any others.

> Yes, agree with Yinghai's fix.  I'll re-spin my patch on top of his.

But he already did it while I slept in.

Thanks Yinghai!
Rusty.
