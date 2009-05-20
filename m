Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZETOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZETOft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZETOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:35:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34724 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZETOfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:35:40 -0400
Message-ID: <4A14153A.9040703@redhat.com>
Date: Wed, 20 May 2009 17:35:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net>
In-Reply-To: <20090520142234.22285.72274.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> (Applies to kvm.git/queue:fd2e987d)
>
> KVM provides a complete virtual system environment for guests, including
> support for injecting interrupts modeled after the real exception/interrupt
> facilities present on the native platform (such as the IDT on x86).
> Virtual interrupts can come from a variety of sources (emulated devices,
> pass-through devices, etc) but all must be injected to the guest via
> the KVM infrastructure.  This patch adds a new mechanism to inject a specific
> interrupt to a guest using a decoupled eventfd mechnanism:  Any legal signal
> on the irqfd (using eventfd semantics from either userspace or kernel) will
> translate into an injected interrupt in the guest at the next available
> interrupt window.
>   

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

