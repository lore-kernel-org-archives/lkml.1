Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbXK0RTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbXK0RTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbXK0RTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:19:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbXK0RTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:19:14 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Date: Tue, 27 Nov 2007 16:24:11 +0100
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@redhat.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271543.11809.ak@suse.de> <20071127144856.GC31376@hmsreliant.think-freely.org>
In-Reply-To: <20071127144856.GC31376@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271624.11914.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So, it sounds to me then, like unless I'm willing to really re-write the APIC
> setup code (which I don't feel qualified to do quite yet), that the immediate
> solution would be to not rely on interrupts in legacy mode, which was according
> to my understanding, what the use of the irqpoll command line option was
> supposed to enable. 

irqpoll won't fix the timer interrupt.

-Andi
