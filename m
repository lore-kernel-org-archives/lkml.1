Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbXLFKYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbXLFKYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXLFKYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:24:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbXLFKYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:24:09 -0500
Date: Thu, 6 Dec 2007 11:23:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
Message-ID: <20071206102334.GE17299@elte.hu>
References: <20071206021857.826386004@mvista.com> <20071206021909.131993721@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206021909.131993721@mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> The port_mutex is actually a semaphore, so easily converted to a 
> struct mutex.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

cool. How far away are we from being able to remove all the semaphore 
code? :-)

	Ingo
