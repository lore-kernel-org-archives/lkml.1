Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZIGPUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZIGPUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZIGPUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:20:35 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:63306 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbZIGPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:20:35 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 17:20:33 +0200
User-Agent: KMail/1.9.9
Cc: Markus Tornqvist <mjt@nysv.org>, Ingo Molnar <mingo@elte.hu>,
       kernel@kolivas.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de
References: <20090907121613.GA32097@elte.hu> <20090907131905.GP28624@nysv.org> <20090907074507.7f00a3ec@infradead.org>
In-Reply-To: <20090907074507.7f00a3ec@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909071720.36428.elendil@planet.nl>
X-OriginalArrivalTime: 07 Sep 2009 15:20:37.0111 (UTC) FILETIME=[C0654070:01CA2FCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009, Arjan van de Ven wrote:
> 4 cores, 8 threads. Which is basically the standard desktop cpu going
> forward... (4 cores already is today, 8 threads is that any day now)

Despite that I'm personally more interested in what I have available here 
*now*. And that's various UP Pentium systems, one dual core Pentium D and 
Core Duo.

I've been running BFS on my laptop today while doing CPU intensive jobs 
(not disk intensive), and I must say that BFS does seem very responsive.
OTOH, I've also noticed some surprising things, such as processors staying 
on lower frequencies while doing CPU-intensive work.

I feels like I have less of the mouse cursor and typing freezes I'm used 
to with CFS, even when I'm *not* doing anything special. I've been 
blaming those on still running with ordered mode ext3, but now I'm 
starting to wonder.

I'll try to do more structured testing, comparisons and measurements 
later. At the very least it's nice to have something to compare _with_.

Cheers,
FJP
