Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYAJGzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYAJGzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAJGz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:55:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51632 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbYAJGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:55:25 -0500
Date: Thu, 10 Jan 2008 07:55:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to
	traditional
Message-ID: <20080110065511.GB23022@elte.hu>
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109220508.686bbda4@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> Subject: Make the 32 bit Frame Pointer backtracer fall back to traditional
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> The 32 bit Frame Pointer backtracer code checks if the EBP is valid to 
> do a backtrace; however currently on a failure it just gives up and 
> prints nothing. That's not very nice; we can do better and still print 
> a decent backtrace.
> 
> This patch changes the backtracer to fall back to the non-framepointer 
> backtracer if the EBP value isn't within the expected range; so on 
> weird stack corruption cases we get at least something out...

thanks, applied. Another nice catch!

	Ingo
