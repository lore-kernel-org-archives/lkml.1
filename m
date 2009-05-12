Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZELSIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZELSIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZELSIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:08:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53541 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZELSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:08:20 -0400
Message-ID: <4A09BB16.90306@redhat.com>
Date: Tue, 12 May 2009 21:08:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v6] kvm: add support for irqfd
References: <20090512040242.5692.99424.stgit@dev.haskins.net>
In-Reply-To: <20090512040242.5692.99424.stgit@dev.haskins.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> (Applies to kvm.git:833367b57)
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
> I am reasonably satisfied with this series, so Avi please consider for
> inclusion.
>   

Looks good.  Please add a way to disassociate an irqfd (for hotunplug) 
and I'll merge.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

