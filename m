Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYGWHtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYGWHtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYGWHtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:49:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYGWHto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:49:44 -0400
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
In-Reply-To: <48862B01.7070907@qumranet.com>
References: <20080717155724.897537670@polymtl.ca>
	 <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com>
	 <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com>
	 <48862B01.7070907@qumranet.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 09:49:06 +0200
Message-Id: <1216799346.7257.125.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 21:46 +0300, Avi Kivity wrote:
> Jan Kiszka wrote:
> > That's true - as long as you don't have to add/remove/modify
> > tracepoints. I had to do this job in the past (not for KVM). Having 1
> > spot in 1 file (based on generic probes) would be handier in that case
> > than 5 spots in 3 files. But if the KVM tracepoints are considered
> > stable in their number and structure, that shouldn't be an issue here.
> >
> >   
> 
> Tracepoints aren't stable; they are artefacts of the implementation.

Which IMHO makes it unsuitable for trace_mark() as that will be exported
to user-space, and every time you change your tracepoints you'll change
user visible things - not nice.

