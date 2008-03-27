Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYC0NVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYC0NVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759511AbYC0NV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:21:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40731 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985AbYC0NV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:21:27 -0400
Subject: Re: What if a TLB flush needed to sleep?
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Luck, Tony" <tony.luck@intel.com>,
       linux-arch@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0803261817110.1115@schroedinger.engr.sgi.com>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
	 <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de>
	 <Pine.LNX.4.64.0803261817110.1115@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 14:20:52 +0100
Message-Id: <1206624052.8514.570.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-26 at 18:19 -0700, Christoph Lameter wrote:
> On Wed, 26 Mar 2008, Thomas Gleixner wrote:
> 
> > Please use a mutex, not a semaphore. semaphores should only be used
> > when you need a counting sempahore.
> 
> Seems that mutexes are mainly useful for 2 processor systems since they 
> do not allow concurrent read sections. We want multiple processors able 
> to reclaim pages within the same vma or file concurrently. This means 
> processors need to be able to concurrently walk potentially long lists of 
> vmas.

confusion between semaphores and rwsems



