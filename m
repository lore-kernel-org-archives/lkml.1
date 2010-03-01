Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0CANPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:15:16 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:51981 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0CANPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:15:15 -0500
Message-ID: <4B8BB6FA.1000505@oss.ntt.co.jp>
Date: Mon, 01 Mar 2010 21:45:46 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com, zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com>
In-Reply-To: <20100301091819.GD16909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov wrote:
> I am looking at improving KVM x86 emulator. Current code does not

Does your plan also include making the emulator independent of KVM?
Could you tell me about the future plan if possible?

> handle some special cases correctly (code execution from ROM, ins/outs
> to/from MMIO) and many exception conditions during instruction emulation
> are not handled correctly. There is a lot of code in emulator that is
> there only for exception propagation. Using setjmp/longjmp will be very
> beneficial here as exception condition during instruction execution
> maps very naturally to setjmp/longjmp, so my question is what about
> adding setjmp/longjmp implementation to the kernel, or alternatively,
> if there is a fear that it can be abused, add it locally to emulator.c?
> Note that instruction emulation is always done in process context.
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

