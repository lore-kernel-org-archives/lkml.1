Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZJJSQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZJJSQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbZJJSQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:16:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:34324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762066AbZJJSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:16:28 -0400
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0910102010180.9428@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
	 <20091010153350.006406413@linutronix.de>
	 <20091010190436.1a48f98e@hyperion.delvare>
	 <alpine.LFD.2.00.0910101907420.9428@localhost.localdomain>
	 <20091010193915.0e34f0e9@hyperion.delvare>
	 <alpine.LFD.2.00.0910102010180.9428@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 20:15:31 +0200
Message-Id: <1255198531.7521.558.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 20:10 +0200, Thomas Gleixner wrote:
> 
> > Will do. I guess I can assume that the patch is from Vincent Sanders,
> > not you, despite the lack of From: header?
> 
> Duh, yes. Missed that.

I'm still wanting to fix quilt mail to not mess that up... maybe I
should sit down and try and grok that stuff again.

