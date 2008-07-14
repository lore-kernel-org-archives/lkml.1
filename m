Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYGNV70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYGNV70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYGNV7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:59:16 -0400
Received: from gw.goop.org ([64.81.55.164]:34380 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYGNV7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:59:15 -0400
Message-ID: <487BCC25.9030204@goop.org>
Date: Mon, 14 Jul 2008 14:59:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/3] x86_64: further cleanup of 32-bit compat syscall
 mechanisms
References: <487877B8.8010505@goop.org> <487A963E.6040307@kernel.org>
In-Reply-To: <487A963E.6040307@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> AMD only supports "syscall" from 32-bit compat usermode.
>> Intel and Centaur(?) only support "sysenter" from 32-bit compat 
>> usermode.
>>
>> Set the X86 feature bits accordingly, and set up the vdso in
>> accordance with those bits.  On the offchance we run on in a 64-bit
>> environment which supports neither syscall nor sysenter from 32-bit
>> mode, then fall back to the int $0x80 vdso.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Acked-by: H. Peter Anvin <hpa@zytor.com> 

Have these been applied to anything yet?

    J
