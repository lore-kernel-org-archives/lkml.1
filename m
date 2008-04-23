Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYDWSQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYDWSQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYDWSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:16:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38992 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbYDWSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:16:22 -0400
Message-ID: <480F7C11.8040302@zytor.com>
Date: Wed, 23 Apr 2008 11:12:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
References: <200804181856.m3IIuKd4007403@hera.kernel.org>	 <1208917076.9212.721.camel@pmac.infradead.org>	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
In-Reply-To: <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Hi David,
> 
> actually, this CONFIG_VM86 was there even before the renaming was done.
> The main questions (imo) - is there any user space application who uses
> these flags? If they are - then even the idea of this patch was a bit bogus,
> and I should *not* remove all these VM86 specific flags but better define them
> as aliases on flags from processor-flags.h.
> 

Hard to know.  VM86 is only used by a handful of applications (DOSEMU, 
X.org, others?) but it's hard to know what exactly they are.

The fact that noone hollered when that CONFIG_VM86 went in is probably a 
good hint that they don't matter, but it's hard to say for sure.

	-hpa

