Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbYLHUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYLHUfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLHUfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:35:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39592 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYLHUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:35:24 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Eric Lacombe <goretux@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl
From: Andi Kleen <andi@firstfloor.org>
References: <200812080002.21192.goretux@gmail.com> <493D7117.9050503@goop.org>
Date: Mon, 08 Dec 2008 21:35:42 +0100
In-Reply-To: <493D7117.9050503@goop.org> (Jeremy Fitzhardinge's message of "Mon, 08 Dec 2008 11:10:15 -0800")
Message-ID: <87bpvme76p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>> The task_struct is also updated in sys_arch_prctl (ARCH_SET_FS and
>> ARCH_SET_GS), so not just on a context switch.
>> How the task structure could be out of date wrt thread.gs and thread.fs?
>> What could be a typical scenario that could induced gs or fs to be
>> modified and not thread.gs and thread.fs?
>>
>
> Not sure.  It could just be redundant.

The process has just changed fs/gs, but not done a context switch yet.

-Andi

-- 
ak@linux.intel.com
