Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbZD1VXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbZD1VXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZD1VXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:23:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZD1VXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:23:30 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904281700220.15947@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
	 <1239979901.23397.4638.camel@laptop>
	 <alpine.DEB.1.10.0904171100510.21575@qirst.com>
	 <1239982137.23397.4684.camel@laptop> <20090423044228.GA2428@ucw.cz>
	 <alpine.DEB.1.10.0904281700220.15947@qirst.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 23:23:16 +0200
Message-Id: <1240953796.7620.160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 17:02 -0400, Christoph Lameter wrote:
> On Thu, 23 Apr 2009, Pavel Machek wrote:
> 
> > I'd say that taking interrupt and returning in below 1000nsec is
> > impossible, even on very fast hw.
> 
> Hmmm.... Could it be that CONFIG_NO_HZ caused the timer interrupt to be
> avoided in earlier releases? NO_HZ theory at least is to only schedule
> interrupts when  necessary. So an interrupt is needed at the end of the
> scheduling intervals and not at HZ frequency.

No, NOHZ only works on idle cpus.
