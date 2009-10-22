Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZJVOaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZJVOaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZJVOaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:30:06 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51650 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZJVOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vodkP4+jovWVHNN8peLMkVpokRjibW1ug/A+sqpWbZLr8GLR326yiH93uZHHVO3UYQ
         lKPxyK+A6+A5DCCK0/HNKHYi2Uj5kkeqJ1xJWMuZ1J6NtUwEVEKmwTw9wRp0PCKTokRd
         QLun5jMZDU088fvnhZ/2N1eiM1jph6BbI5M6M=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: include/asm-generic/int-ll64.h kernel 2.6.31.4
Date: Thu, 22 Oct 2009 16:29:59 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20091020154305.8338b765.skraw@ithnet.com>
In-Reply-To: <20091020154305.8338b765.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910221629.59818.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009, Stephan von Krawczynski wrote:
> I lately compiled some app that stumbled across this, and someone smarter than
> me should judge if this is right or wrong:
> 
> 
> * asm-generic/int-ll64.h
>  *
>  * Integer declarations for architectures which use "long long"
>  * for 64-bit types.
>  */
> 
> #ifndef _ASM_GENERIC_INT_LL64_H
> #define _ASM_GENERIC_INT_LL64_H
> 
> #include <asm/bitsperlong.h>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
> Is it correct to include from linked "asm" instead of asm-generic ?
> 
> My link goes to "asm-x86" but for some reason asm-generic/types.h is included
> which ends at int-ll64.h trying to include a not existing bitsperlong.h from
> directory asm-x86.

Hi Stephan,

Most likely you are using the kernel headers in an unsupported way, like
trying to point to $(HOME)/linux-2.6/include for include files when building
an application.

Please see http://kernelnewbies.org/KernelHeaders for how to fix that.

	Arnd <><
