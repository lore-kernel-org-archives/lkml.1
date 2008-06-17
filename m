Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYFQNuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYFQNuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbYFQNue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:50:34 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:44350 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752862AbYFQNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:50:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAPhcV0hMQW1O/2dsb2JhbACBW60V
Date: Tue, 17 Jun 2008 09:50:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
Message-ID: <20080617135031.GA10316@Krystal>
References: <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal> <20080616162212.27a8c119@linux360.ro> <20080616164609.GM20851@kernel.dk> <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com> <20080616182843.GS20851@kernel.dk> <20080617153934.59a7c7ee@linux360.ro> <20080617154923.36195161@linux360.ro> <20080617131036.GB8696@Krystal> <20080617163551.49f96c7d@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080617163551.49f96c7d@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:50:06 up 12 days, 18:31,  4 users,  load average: 0.34, 0.40,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Tue, 17 Jun 2008 09:10:36 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Do you get the same results when not using a buffered read to read
> > /proc/PID/stat ? Also, since the internal proc handle might buffer the
> > information, closing the file and re-opening it after the set affinity
> > would not be a bad idea.
> > 
> > Mathieu
> 
> Tested your suggestions now, looks fine. 5 instances end up on CPU 1,
> one on CPU 0, no errors printed by the application.
> 

Yeah, although using set affinity with CPU hotplug is broken by design.

Mathieu

> 
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
