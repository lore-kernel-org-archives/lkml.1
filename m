Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZISOy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZISOy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 10:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZISOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 10:54:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:57295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZISOyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 10:54:54 -0400
Date: Sat, 19 Sep 2009 16:55:01 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tickless and HZ=1000 throughput advantage?
Message-ID: <20090919165501.65d77294@infradead.org>
In-Reply-To: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
References: <6278d2220909190747n62f7036dj2e5231fcdc4730fb@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009 15:47:24 +0100
Daniel J Blueman <daniel.blueman@gmail.com> wrote:

> On tickless kernels, is the general consensus that for non-embedded
> systems, selecting HZ=1000 gives slightly more throughput in
> particular situations than HZ=100 or 250, due to finer timer
> intervals/granularity?

it's not about throughput. It's about latency for some things....
although now that select/poll and co use hrtimers it's not as critical
anymore.

the HZ timers aren't used much for anything time-critical nowadays.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
