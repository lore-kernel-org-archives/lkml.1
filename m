Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbXHOVxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbXHOVxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXHOVxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:53:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:59197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbXHOVxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:53:16 -0400
Date: Thu, 16 Aug 2007 00:47:18 +0200
From: Andi Kleen <ak@suse.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Steven Rostedt <rostedt@goodmis.org>,
       kiran@scalemp.com, shai@scalemp.com
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
Message-ID: <20070815224718.GO3406@bingen.suse.de>
References: <11871822163867-git-send-email-gcosta@redhat.com> <20070815135554.GE3406@bingen.suse.de> <5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com> <20070815154243.GH3406@bingen.suse.de> <46C31736.2050001@redhat.com> <20070815163640.GJ3406@bingen.suse.de> <46C3283B.5090804@redhat.com> <20070815164729.GU3672@sequoia.sous-sol.org> <46C3312D.40106@redhat.com> <20070815180929.GX3672@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815180929.GX3672@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> between __cacheline_aligned_in_smp and other compile time bits based on
> VSMP specific INTERNODE_CACHE, etc. I think compile time the way to go.

Yes you're right they'll need an additional build option for that.
It would be too wasteful to have the big cache line for all paravirt kernels.
But it can be below paravirt ops and at least clean up the 
interrupt saving code.

-Andi

