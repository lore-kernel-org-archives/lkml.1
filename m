Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbZIXORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbZIXORr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIXORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:17:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbZIXORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:17:46 -0400
Message-ID: <4ABB7F58.5030508@zytor.com>
Date: Thu, 24 Sep 2009 07:16:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu> <20090924140228.GA2648@redhat.com>
In-Reply-To: <20090924140228.GA2648@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> 
> http://marc.info/?l=linux-kernel&m=125200966226921&w=2
> 
> The basic idea is that gcc, 4.5 will have support for an 'asm goto'
> construct which can refer to c code labels. Thus, we can replace a nop
> in the code stream with a 'jmp' instruction to various branch targets.
> 

Looking at the above, I'm a bit unclear for the need for a NOP5.  We 
obviously need a *total* of 5 bytes, but at least I don't seem to 
understand why we need 7 bytes per tracepoint.

	-hpa

