Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbYDPPhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbYDPPhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbYDPPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:37:34 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:62705 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755901AbYDPPhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:37:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EADu6BUhMROPA/2dsb2JhbACBYK0u
Date: Wed, 16 Apr 2008 11:37:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
Message-ID: <20080416153731.GA17852@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416151054.GA32456@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:34:50 up 47 days, 11:45,  4 users,  load average: 0.04, 0.22,
	0.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > thanks Mathieu, i've picked this up into x86.git for more testing.
> 
> ... but had to drop it due to missing PARAVIRT support which broke the 
> build. I guess on paravirt we could just initially define 
> INTERRUPT_RETURN_NMI_SAFE to iret, etc.?
> 

Yes, I was about to email you about this.

Would it be valid to execute a popf in PARAVIRT or should be have some
special support like the normal iret does ?

And yes, initially using iret for paravirt should just work, but it
would leave the NMI iret issue for paravirt.

Mathieu

> 	Ingo
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
