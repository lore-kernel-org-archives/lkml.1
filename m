Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYC1J7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYC1J7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYC1J7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:59:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYC1J7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:59:44 -0400
Subject: Re: What if a TLB flush needed to sleep?
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
       linux-arch@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803271143540.7531@schroedinger.engr.sgi.com>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
	 <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de>
	 <Pine.LNX.4.64.0803261817110.1115@schroedinger.engr.sgi.com>
	 <1206624052.8514.570.camel@twins>
	 <Pine.LNX.4.64.0803271143540.7531@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 10:59:31 +0100
Message-Id: <1206698371.8514.608.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 11:44 -0700, Christoph Lameter wrote:
> On Thu, 27 Mar 2008, Peter Zijlstra wrote:
> 
> > confusion between semaphores and rwsems
> 
> rwsem is not a semaphore despite its name? What do you want to call it 
> then?

Its not a real counting semaphore, a sleeping rw lock might be a better
name as opposed to the contradition rw-mutex :-)

But lets just call it a rwsem; we all know what that is.


