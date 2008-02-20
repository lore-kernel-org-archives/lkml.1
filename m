Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYBTE5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYBTE5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYBTE5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:57:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752086AbYBTE5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:57:39 -0500
Date: Tue, 19 Feb 2008 22:57:33 -0600
From: Paul Jackson <pj@sgi.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, pavel@ucw.cz,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, marcelo@kvack.org,
       daniel.spang@gmail.com, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-fsdevel@vger.kernel.org,
       a1426z@gawab.com, jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Message-Id: <20080219225733.37c56eb2.pj@sgi.com>
In-Reply-To: <20080220114317.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080219222828.GB28786@elf.ucw.cz>
	<20080219210739.27325078@bree.surriel.com>
	<20080220114317.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kosaki-san wrote:
> Yes.
> Fujitsu HPC middleware watching sum of memory consumption of the job
> and, if over-consumption happened, kill process and remove job schedule.

Did those jobs share nodes -- sometimes two or more jobs using the same
nodes?  I am sure SGI has such users too, though such job mixes make
the runtimes of specific jobs less obvious, so customers are more
tolerant of variations and some inefficiencies, as they get hidden in
the mix.

In other words, Rik, both yes and no ;).  Both sorts of HPC loads
exist, sharing nodes and a dedicated set of nodes for each job.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
