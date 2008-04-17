Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYDQOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYDQOB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYDQOBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:01:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYDQOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:01:47 -0400
Date: Thu, 17 Apr 2008 07:01:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417070129.2bb99e2c@laptopd505.fenrus.org>
In-Reply-To: <20080417103800.GA27250@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
	<20080417033333.947dfcc9.akpm@linux-foundation.org>
	<20080417103800.GA27250@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 12:38:00 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Thank you whoever wrote kmemcheck.txt
> > 
> > How come slub uses one byte to track the status of each byte when
> > it could use a single bit?
> > 
> > We (still!) have not made the decision whether to proceed with slab
> > or slub.  How hard would it be to port kmemcheck into slab?
> 
> i think slab is clearly out, unless some catastrophic regression is 
> found. 

SLUB still has that several percent TPC-C regression....
Christoph has a small reproducer testcase.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
