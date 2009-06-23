Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbZFWPck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbZFWPck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbZFWPbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:31:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:48685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007AbZFWPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:31:04 -0400
Subject: Re: [perf] howto switch from pfmon
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090623145127.GB13415@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>
	 <4A40E4E2.3090002@inria.fr>  <20090623145127.GB13415@elte.hu>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 20:59:15 +0530
Message-Id: <1245770955.3776.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 16:51 +0200, Ingo Molnar wrote:
> Per thread info is currently available in the profile output:
> 
>    perf report --sort comm,pid,symbol
> 
> But it would be nice to either extend perf report with a --stat 
> option:
> 
>    perf report --stat
> 
> or to extend perf stat to take an input file via -i:
> 
>    perf stat -i perf.data
> 

I prefer 'perf report --stat' as it is already handling file.

--
JSR

