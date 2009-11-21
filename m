Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZKUStu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZKUStu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZKUStu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:49:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53614 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZKUStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:49:49 -0500
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
References: <20091120211139.GB19106@sgi.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 21 Nov 2009 10:49:50 -0800
In-Reply-To: <20091120211139.GB19106@sgi.com> (Dimitri Sivanich's message of "Fri\, 20 Nov 2009 15\:11\:39 -0600")
Message-ID: <m1r5rrr9v5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich <sivanich@sgi.com> writes:

> This patch allows for hard numa restrictions to irq affinity on x86 systems.
>
> Affinity is masked to allow only those cpus which the subarchitecture
> deems accessible by the given irq.
>
> On some UV systems, this domain will be limited to the nodes accessible
> to the irq's node.  Initially other X86 systems will not mask off any cpus
> so non-UV systems will remain unaffected.

Is this a hardware restriction you are trying to model?
If not this seems wrong.

Eric
