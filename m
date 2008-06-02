Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYFBP2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYFBP2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYFBP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:28:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34282 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbYFBP2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:28:32 -0400
Message-ID: <484411A3.2000205@sgi.com>
Date: Mon, 02 Jun 2008 08:28:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Further percpu/pda unification?
References: <48440264.5060506@goop.org>
In-Reply-To: <48440264.5060506@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I notice that there's now a unified asm-x86/percpu.h, and the pda is now
> a per-cpu variable.  But I also see that most of the stuff in percpu.h
> is 32-bit only: all the accessor macros, x86_read/write_percpu, etc.  Is
> there some reason why that can't be made common, or is it just that
> nobody has got around to it yet?
> 
> Thanks,
>    J

Hi Jeremy,

I'll have a further unification patch shortly, just doing final testing now.

Thanks,
Mike
