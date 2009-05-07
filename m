Return-Path: <linux-kernel-owner+w=401wt.eu-S1760507AbZEGRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbZEGRii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZEGRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:38:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760507AbZEGRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:38:19 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071317270.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop>
	 <alpine.DEB.1.10.0905071317270.22107@qirst.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:37:29 +0200
Message-Id: <1241717849.6311.1554.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 13:18 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > Therefore, decreasing the HZ value to say 50, we'd get a minimum
> > involuntary preemption granularity of 20ms, something on the high end of
> > barely usable.
> 
> But the schedule is activated when a process is being woken up. The main
> use is for load balancing.

Somehow people like involuntary preemption to happen at slightly more
than glacial pace as well.



