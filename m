Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZIDQ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZIDQ2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZIDQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:28:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbZIDQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:28:30 -0400
Message-ID: <4AA13FCB.6050801@zytor.com>
Date: Fri, 04 Sep 2009 09:26:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, petkovbb@googlemail.com,
       tglx@linutronix.de, petkovbb@gmail.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, msr: Add rd/wrmsr interfaces with preset	registers
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com> <tip-132ec92f3f70fe365c1f4b8d46e66cf8a2a16880@git.kernel.org> <20090904140834.GA15789@elte.hu>
In-Reply-To: <20090904140834.GA15789@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 07:08 AM, Ingo Molnar wrote:
> * tip-bot for Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
>> Commit-ID:  132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
>> Gitweb:     http://git.kernel.org/tip/132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
>> Author:     Borislav Petkov <petkovbb@googlemail.com>
>> AuthorDate: Mon, 31 Aug 2009 09:50:09 +0200
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Mon, 31 Aug 2009 15:14:26 -0700
>>
>> x86, msr: Add rd/wrmsr interfaces with preset registers
> 
> module exports are missing:
> 
>  ERROR: "native_wrmsr_safe_regs" [arch/x86/kernel/msr.ko] undefined!
>  ERROR: "native_rdmsr_safe_regs" [arch/x86/kernel/msr.ko] undefined!
> 

Uglier than that, msr-reg.o is defined as lib-y, which probably means
it's discarded completely if the kernel proper doesn't link it in.

It probably needs a new Kconfig variable or something... let me think
about it for a little bit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

