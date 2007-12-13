Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXLMPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXLMPQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbXLMPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:16:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49040 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbXLMPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:16:21 -0500
Date: Thu, 13 Dec 2007 16:16:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071213151629.GB31269@one.firstfloor.org>
References: <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de> <20071212155515.GA29735@hmsendeavour.rdu.redhat.com> <20071212160722.GD4889@bingen.suse.de> <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com> <20071212202215.GB29735@hmsendeavour.rdu.redhat.com> <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com> <20071213143922.GA4674@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213143922.GA4674@hmsreliant.think-freely.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:39:22AM -0500, Neil Horman wrote:
> 
> Ok, new patch attached, taking into account Andi's request for a cleaner method

Sorry for not noticing that earlier, but was there a specific reason this needs
to be an early quirk at all? kexec can only happen after the standard quirks ran.
I think it should be fine as a standard "late" quirk.

-Andi
