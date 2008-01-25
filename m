Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYAYKwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYAYKwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYAYKwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:52:37 -0500
Received: from mail.suse.de ([195.135.220.2]:33051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYAYKwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:52:36 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86.git: mtrr trimming removes all memory under kvm
From: Andi Kleen <andi@firstfloor.org>
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com>
	<200801241832.55910.yinghai.lu@sun.com>
Date: Fri, 25 Jan 2008 11:52:35 +0100
In-Reply-To: <200801241832.55910.yinghai.lu@sun.com> (Yinghai Lu's message of "Thu\, 24 Jan 2008 18\:32\:55 -0800")
Message-ID: <p738x2e9nyk.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>  
> +	/* Doesn't apply to memory < 4GB */
> +	if (end_pfn <= (0xffffffffUL >> PAGE_SHIFT))
> +		return 0;

I don't think this makes sense to move outside the AMD workaround
because the normal MTRRs don't have an implicit hidden 4GB semantics.

-Andi
