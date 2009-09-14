Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZINNuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZINNuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZINNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZINNuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:50:35 -0400
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree
 build warning)
From: Steven Rostedt <srostedt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090912073906.GA3972@elte.hu>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Sep 2009 09:50:01 -0400
Message-Id: <1252936201.2964.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:39 +0200, Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > Now that this is in Linus' tree, can we have a fix for the waning, 
> > please?
> 
> The first warning got fixed 1.5 months ago - the second one at line 
> 797 is still there but harmless - you can ignore it for now, it will 
> be fixed.

The first warning never got fixed. The typecast was placed in the wrong
spot (my fault). I sent another patch that fixes both warnings.

-- Steve


