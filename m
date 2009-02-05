Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZBETDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZBETDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZBETCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:02:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52629 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbZBETCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:02:54 -0500
Date: Thu, 5 Feb 2009 20:02:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       akataria@vmware.com, Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH 1/2] show hypervisor information on cpuinfo
Message-ID: <20090205190250.GE20470@elte.hu>
References: <1233859341-10419-1-git-send-email-glommer@redhat.com> <1233859341-10419-2-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233859341-10419-2-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <glommer@redhat.com> wrote:

> +char * __cpuinit hypervisor_str(struct cpuinfo_x86 *c)
> +{
> +	if (c->x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE)
> +		return "VMWare";
> +	else
> +		return "none";
> +}

i'd suggest these variants instead:

 virtualization:	native kernel
 virtualization:	KVM guest
 virtualization:	VMWare guest
 virtualization:	Linux guest

	Ingo
