Return-Path: <linux-kernel-owner+w=401wt.eu-S1751601AbZGVJTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbZGVJTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZGVJTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:19:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZGVJTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:19:09 -0400
Date: Wed, 22 Jul 2009 11:18:40 +0200
From: John Kacur <jkacur@redhat.com>
To: linux-rt-users@vger.kernel.org,
       Wolfgang Steinwender <wolfgang@psysteme.de>,
       Carsten Emde <Carsten.Emde@osadl.org>, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
       Jon Masters <jcm@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Problem with hwlat detector in smp_processor_id()
Message-ID: <20090722091840.GC3507@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tested this patch against 2.6.29.6-rt23 and 2.6.31-rc3-rtx
and it seems to solve the problem for me. I have not tested against vanilla
2.6.31-rc3 yet, but it looks to me like it should be applied there too.
(not just as an extra -rt patch)

