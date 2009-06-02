Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZFBPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZFBPoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFBPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:43:54 -0400
Received: from www.tglx.de ([62.245.132.106]:51481 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZFBPnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:43:52 -0400
Date: Tue, 2 Jun 2009 17:37:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/16] xen: disable PAT
In-Reply-To: <1242163718-2934-7-git-send-email-jeremy@goop.org>
Message-ID: <alpine.LFD.2.00.0906021736320.3419@localhost.localdomain>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org> <1242163718-2934-7-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Jeremy Fitzhardinge wrote:

> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Xen imposes a particular PAT layout on all paravirtual guests which
> does not match the layout Linux would like to use.
> 
> Force PAT to be disabled until this is resolved.

No, this can be done via CPUID, which is paravirtualized already.
 
Thanks,

	tglx
