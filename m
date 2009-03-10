Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZCJRpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZCJRpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZCJRpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:45:04 -0400
Received: from waste.org ([66.93.16.53]:48479 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZCJRpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:45:03 -0400
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
From: Matt Mackall <mpm@selenic.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org
In-Reply-To: <49B6A374.6040805@hp.com>
References: <49B68450.9000505@hp.com> <1236705532.3205.14.camel@calx>
	 <49B6A374.6040805@hp.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 12:43:50 -0500
Message-Id: <1236707030.3205.21.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 13:29 -0400, Alan D. Brunelle wrote:
> Matt Mackall wrote:
> > On Tue, 2009-03-10 at 11:16 -0400, Alan D. Brunelle wrote:
> >> Running blktrace & I/O loads cause a kernel BUG at mm/slab.c:3002!.
> > 
> > Pid: 11346, comm: blktrace Tainted: G    B      2.6.29-rc7 #3 ProLiant
> > DL585 G5   
> > 
> > That 'B' there indicates you've hit 'bad page' before this. That bug
> > seems to be strongly correlated with some form of hardware trouble.
> > Unfortunately, that makes everything after that point a little suspect.
> 
> 
> /If/ it were a hardware issue, that might explain the subsequent issue
> when I switched to SLUB instead...

Well it was almost certainly not a bug in SLAB itself (and your SLUB
test is obviously quite conclusive there). We'd have lots of reports.
It's probably too early to conclude it's hardware though.

> How does one look for "bad page reports"?

It'll look something like this (pasted from Google):

>>     kernel: Bad page state at free_hot_cold_page (in process 'beam',
>> page c1a95320)
>>     kernel: flags:0x40020118 mapping:f401adc0 mapped:0 count:0
>> private:0x00000000

-- 
http://selenic.com : development and support for Mercurial and Linux


