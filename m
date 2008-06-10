Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYFJUNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYFJUNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYFJUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:13:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:37846 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbYFJUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:13:12 -0400
Date: Tue, 10 Jun 2008 13:13:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: no cpu MHz in /proc/cpuinfo on 2.6.25.4-rt6
Message-ID: <20080610131314.5f7069e6@infradead.org>
In-Reply-To: <200806102152.23286.solstice.dhiver@gmail.com>
References: <200806102152.23286.solstice.dhiver@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 21:52:23 +0200
solsTiCe d'Hiver <solstice.dhiver@gmail.com> wrote:

> hi,
> 
> i am running a 2.6.25.5-rt6 kernel.
> i know there is no such thing as 2.6.25.5-rt6 yet. so i have checked
> with a 2.6.25.4-rt6 kernel and i have the same issue.
> 
> when i try to run jackd (0.109.2) i get that strange error:
> FATAL: cannot locate cpu MHz in /proc/cpuinfo
> 
> and it appears that /proc/cpuinfo lack the line 
> cpu MHz:


btw this is scary; the Mhz line in /proc/cpuinfo doesn't have much
meaning really, so applications using it and depending on it is a
rather big disaster ;-(

Does anyone know why jackd wants to use this?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
