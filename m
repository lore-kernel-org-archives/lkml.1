Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbYDPP0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbYDPP0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYDPP0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:26:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYDPP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:26:16 -0400
Message-ID: <480618BC.1030800@zytor.com>
Date: Wed, 16 Apr 2008 11:18:20 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu>
In-Reply-To: <20080416151054.GA32456@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> thanks Mathieu, i've picked this up into x86.git for more testing.
> 
> ... but had to drop it due to missing PARAVIRT support which broke the 
> build. I guess on paravirt we could just initially define 
> INTERRUPT_RETURN_NMI_SAFE to iret, etc.?

I figure that's what we'd have to do.  This is exactly the fundamental 
problem with paravirt - it relies on a different, an ill-defined, model 
of the platform than the (generally well-defined) hardware specification 
provides.


	-hpa
