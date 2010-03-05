Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0CERCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:02:09 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:61445 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0CERCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:02:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=Bew7KHqrfYHxp5/5Aiv1FctjX8Hon559
	XGfmCNnq+z5h8cYqFhSP9hlPo/NbDX1PTzXZN7VmtoeIsCdtp+3fib05ZGdq2VJl
	O0Wt69B77PpUmJXHxdZFLUrw00E/fQeKdcqg4pFzcwvzr03umiF772ZUOzsz6rJx
	3tX1lDbY/zw=
To: Johannes Sixt <j.sixt@viscovery.net>
Cc: Jiri Slaby <jirislaby@gmail.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: gitignore broken in git 1.7.0.1: slash checks leading dirs
References: <4B90C701.3070308@gmail.com> <4B90C974.2050405@viscovery.net>
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 05 Mar 2010 09:01:16 -0800
In-Reply-To: <4B90C974.2050405@viscovery.net> (Johannes Sixt's message of
 "Fri\, 05 Mar 2010 10\:05\:56 +0100")
Message-ID: <7vhbou1z4z.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: BCBD651C-2878-11DF-B8E3-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Sixt <j.sixt@viscovery.net> writes:

> Jiri Slaby schrieb:
>> having 'linux' line in .gitignore makes 'include/linux/vga_switcheroo.h'
>> to be ignored
>
> That's the behavior that I would expect.

Also the initial report made it sound as if there were a regression, but
it doesn't seem to be the case; I don't see it behaving any differently
among 1.7.0, 1.7.0.1, 1.6.0, 1.6.6, or even 1.5.4.




