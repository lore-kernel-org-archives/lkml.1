Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZKKHSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZKKHSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZKKHSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:18:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51923 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZKKHSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:18:40 -0500
Date: Wed, 11 Nov 2009 08:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Message-ID: <20091111071832.GA3156@elte.hu>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com>
 <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <4AF7C66C.6000009@zytor.com>
 <20091109080830.GI453@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ma, Ling <ling.ma@intel.com> wrote:

> Hi All
> Please use the memcpy.c(cc -o memcpy memcpy.c -O2) to test more cases,
> if you have interest. In this program we did simple modification
> on memcpy_new function.

FYI:

earth4:~/s> cc -o memcpy memcpy.c -O2
memcpy.c: In function 'do_one_throughput':
memcpy.c:45: error: impossible register constraint in 'asm'
memcpy.c:53: error: impossible register constraint in 'asm'
memcpy.c:47: error: impossible register constraint in 'asm'
memcpy.c:53: error: impossible register constraint in 'asm'

	Ingo
