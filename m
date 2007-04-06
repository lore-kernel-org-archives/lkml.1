Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXDFAJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXDFAJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDFAJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:09:25 -0400
Received: from gw.goop.org ([64.81.55.164]:39317 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbXDFAJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:09:24 -0400
Message-ID: <46158F8E.1050807@goop.org>
Date: Thu, 05 Apr 2007 17:08:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com>
In-Reply-To: <46158DE1.4050508@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Well at this point, the "proper" fix is dependent on Jeremy's
> kmap_atomic_pte changes, which are definitely too late to pull into
> 2.6.21.  Can we just apply this patch please? 

Hm, I think they're independent aren't they?  Your fix is about making
lazy_mmu disable interrupts; that's independent of how highpte pages get
mapped.

    J

