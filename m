Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYE0QMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYE0QMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbYE0QLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:11:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:33571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757543AbYE0QLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:11:52 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+LkeFD3XWLue3OeyIHiD4CfNWc6UcreCrikCr6vn
	pWM700Fulz/XcV
Date: Tue, 27 May 2008 18:11:48 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080527161148.GA7291@alice>
References: <20080526143422.GA3203@alice> <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com> <20080527151136.GA20750@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080527151136.GA20750@alice>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc3 (x86_64)
X-Uptime: 18:02:30 up  5:19,  1 user,  load average: 0.26, 0.43, 0.48
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> * Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> 
> I am currently trying to reproduce this with SLAB as Vegard
> suggested for the kmemcheck report. After this I'll retest this
> on a fresh tree to make sure it isnt something buggy on my part
> and try some older kernels.

ok, with CONFIG_SECURITY, SLAB and CONFIG_DEBUG_SLAB on the
-rc3 based kmemcheck tree enabled i dont get any error.
I am currently building a fresh -rc4 (with SLUB) to make
sure this is for real, then i'll try that again with SLAB
and then start testing older kernels. 

Greetings, Eric

