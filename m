Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZAHSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZAHSZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZAHSZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:25:32 -0500
Received: from waste.org ([66.93.16.53]:48848 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZAHSZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:25:32 -0500
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090108120619.GF1539@elte.hu>
References: <496534B1.6080902@kernel.org>  <20090108120619.GF1539@elte.hu>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:17:58 -0600
Message-Id: <1231435078.3178.278.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 13:06 +0100, Ingo Molnar wrote:
> (Matt Cc:-ed)
> 
> Matt, does this look good to you? The point of this cleanup would be to 
> make desc->timer_rand_state depend on hardirq (the presence of irq_desc[]) 
> - not sparseirq (which does not make much sense).

Seems fine.

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

