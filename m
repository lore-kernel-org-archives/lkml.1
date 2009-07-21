Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbZGUEAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbZGUEAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZGUEAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:00:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZGUEAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:00:50 -0400
Message-ID: <4A653D39.4030608@kernel.org>
Date: Mon, 20 Jul 2009 20:59:53 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Uros Bizjak <ubizjak@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH, x86]: Fix movq immediate operand constraints in uaccess_64.h
References: <4A63448B.1050208@gmail.com> <4A64D06D.3040109@gmail.com>
In-Reply-To: <4A64D06D.3040109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uros Bizjak wrote:
> On 07/19/2009 06:06 PM, Uros Bizjak wrote:
>> Hello!
>>
>> arch/x86/include/asm/uaccess_64.h uses wrong asm operand constraint
>> ("ir") for movq insn. Since movq sign-extends its immediate operand,
>> "er" constraint should be used instead.
>>
>> Attached patch changes all uses of __put_user_asm in uaccess_64.h to
>> use "er" when "q" insn suffix is involved.
>>
>> Patch was compile tested on x86_64 with defconfig.
>>
>> Uros.
> 
> Uh, missed signed-off line and Cc, so:
> 

Good catch.  This seems to also apply to the "Zr" constraints in
asm/uaccess.h.

	-hpa
