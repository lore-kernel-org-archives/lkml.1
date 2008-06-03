Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYFCGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYFCGEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYFCGEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:04:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:2083 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYFCGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XmMFYH233JPxZ0c4aWHhsTxdR4YMo9JqpZT0H9oykz9wDmrYLl6K3ZE6zByKjM2rd5hU90nwojGGfOfsz18ou1JmOOkvRY07msHfgQN8DlJRuaLfAAylBYo8dNnuhQYKMiyZbO8L+Z5aUR9FGXPD7oa8JMN6AlKIVExxrITQgK8=
Message-ID: <3877989d0806022304w35764b17p9d4c3c95eceae0f5@mail.gmail.com>
Date: Tue, 3 Jun 2008 14:04:39 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Petr Tesarik" <ptesarik@suse.cz>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Roland McGrath" <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <1211869515.29836.2.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
	 <1211869515.29836.2.camel@elijah.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 2:25 PM, Petr Tesarik <ptesarik@suse.cz> wrote:
> On Mon, 2008-05-26 at 23:12 -0700, Roland McGrath wrote:
>> >  [<a00000010000a9f0>] skip_rbs_switch+0xe0/0x110
>> >                                 sp=e000000141c9fe30 bsp=e000000141c90cf8
>> >  [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
>> >                                 sp=e000000141ca0000 bsp=e000000141c90cf8
>
> Indeed, there seems to be a large hole here. So, this is either a bug in
> the unwinder, or a bug in the RBS synchronization, which causes
> corruption. My test machine currently needs some work to run 2.6.25
> again, but I'll try your test case as soon as I re-install it later this
> week.

Just want to check if the test case works for you?
