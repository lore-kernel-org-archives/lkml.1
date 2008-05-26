Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYEZBav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYEZBav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 21:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYEZBal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 21:30:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:51595 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYEZBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 21:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lW1KdH/TztmEw8FU8STtXZeBasTcQ/hwi7mpq6zw3qYeWQvFfmFeg+6ni+lfm6Bg4P/cCI4ku/Ep5ZyPf4ZjMf0kj8RnAve3V++vTXTCUMR64GQ3C9qe5Dof1Uxd+2xS+ywhl7D3THClIVDhcgGyq5JFu92Ou1ut2RbDJ+nsUnk=
Message-ID: <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
Date: Mon, 26 May 2008 09:30:39 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080526001527.81E1126FA9E@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <1211446045.5610.33.camel@elijah.suse.cz>
	 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	 <20080522111826.BB90326FA24@magilla.localdomain>
	 <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	 <20080522203428.835D626FA24@magilla.localdomain>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 8:15 AM, Roland McGrath <roland@redhat.com> wrote:
>> "deliver" here I mean get_signal_to_deliver()...
>
> This can never happen inside ptrace_stop.
> So your line of inquiry doesn't make sense to me.

if happens, it should be a bug, right?

>
> Please tell us the exact code path you think is happening in the error case
> you can reproduce.
>
I will try to customize kernel to capture call trace for a precise code path.

--Luming
