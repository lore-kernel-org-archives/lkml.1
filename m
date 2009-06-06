Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZFFWAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZFFWAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZFFWAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:00:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722AbZFFWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:00:35 -0400
Date: Sat, 6 Jun 2009 14:58:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] cpumask: introduce zalloc_cpumask_var
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Message-ID: <alpine.LFD.2.01.0906061457070.6847@localhost.localdomain>
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com>
 <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Jun 2009, Yinghai Lu wrote:
> 
> so could get cpumask_var with cpumask_clear

Ok, this whole series looks much nicer than the hacky "add __GFP_ZERO in 
random places".

ACK, as far as I'm concerned.

		Linus
