Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbZB0Vb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbZB0Vb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbZB0Vbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:31:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZB0Vbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:31:49 -0500
Message-ID: <49A85AF8.8030009@zytor.com>
Date: Fri, 27 Feb 2009 13:28:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: add brk allocation for very, very early allocations
References: <49A829CE.9020509@goop.org> <49A84C5A.3020304@kernel.org> <49A855B7.4090204@zytor.com> <49A858E8.3070707@goop.org>
In-Reply-To: <49A858E8.3070707@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
>> This reminds me... is your intent that the BRK is permanent (unless
>> explicitly freed on a page by page basis) or part of the init memory
>> that is flushed?
> 
> Permanent.  I'm using it to allocate things which are the moral
> equivalent of the kernel pagetables.
> 

Cool; just wanted it noted what the rules were.  Even more so the reason
to fold as many possible uses as possible into this new mechanism.

	-hpa

P.S. Could you send me the updates to the dom0 patches you said you had?

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

