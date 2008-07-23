Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYGWKDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYGWKDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 06:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGWKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 06:03:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYGWKDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 06:03:46 -0400
Date: Wed, 23 Jul 2008 06:03:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@qumranet.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
Message-ID: <20080723100314.GA2847@infradead.org>
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com> <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins> <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216803303.7257.138.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:55:03AM +0200, Peter Zijlstra wrote:
> Andrew raised the whole point about trace_mark() generating an
> user-visible interface and thus it should be stable, and I agree with
> that.

I'm not sure why this comes up again and again, but it's utter bullshit.
trace_mark does not generate any kind of user interface, just purely
a kernel internal interface.

