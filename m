Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZCJFdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZCJFdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZCJFde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:33:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:50736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZCJFdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:33:33 -0400
Message-ID: <49B5FB69.2020909@kernel.org>
Date: Mon, 09 Mar 2009 22:32:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Absolute symbols in vmlinux_64.lds.S
References: <3k2vgeyfr0tl8gef3ia8o9rh.1236659870536@email.android.com>
In-Reply-To: <3k2vgeyfr0tl8gef3ia8o9rh.1236659870536@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Jeremy Fitzhardinge wrote:
>>> Why does vmlinux_64.lds.S use absolute symbols for things like
>>> __bss_start/stop:
>>>
>>>  __bss_start = .;        /* BSS */
>>>  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
>>>     *(.bss.page_aligned)
>>>     *(.bss)
>>>     }
>>>  __bss_stop = .;
>>>
>>>
>>> vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is
>>> there some particular reason they need to be absolute symbols
>>> (relocation?).
>>>
>> they are the same.
> 
> Do you mean it makes no difference?

Sure. System.map should tell the value after the building.

YH
