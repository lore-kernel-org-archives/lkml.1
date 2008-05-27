Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYE0Geh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYE0Geh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYE0Ge1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:34:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10562 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbYE0Ge0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B09Sh93Tp9KNv042kXr7PFQrDy88sFVVyqhrq4mllQaGzco70YKZ3LwuGUqFCorvSPFslEM/KFipnEQPyllXhCgUZpdLZID7fU/UMdI2F4VixlRCmUAHMxqYpOe6+wZBg/NTUs9ADOCpS/53xSisXACJDPtKMdirK2eqIJcVzSk=
Message-ID: <3877989d0805262334j1ce4d0efhe05e0aa8c3975a28@mail.gmail.com>
Date: Tue, 27 May 2008 14:34:26 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080527061209.9A24426FAA6@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 2:12 PM, Roland McGrath <roland@redhat.com> wrote:
>>  [<a00000010000a9f0>] skip_rbs_switch+0xe0/0x110
>>                                 sp=e000000141c9fe30 bsp=e000000141c90cf8
>>  [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
>>                                 sp=e000000141ca0000 bsp=e000000141c90cf8
>>  [<a0000001000971c0>] ptrace_stop+0xa0/0x3e0
>>                                 sp=e00000014716fdb0 bsp=e000000147160ca8
>>  [<a000000100097650>] ptrace_notify+0x150/0x1c0
>>                                 sp=e00000014716fdb0 bsp=e000000147160c88
>
> If this is a backtrace of a single thread on the same kernel stack, it has
> a stack depth of over 84MB.  You still need to follow the path inside

you are right, I just find outputs of two different thread are mixed!
Please just ignore the call trace above..
