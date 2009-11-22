Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZKVBO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZKVBO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 20:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZKVBOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 20:14:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54272 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751292AbZKVBOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 20:14:55 -0500
Date: Sat, 21 Nov 2009 19:14:57 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091122011457.GA16910@sgi.com>
References: <20091120211139.GB19106@sgi.com> <m1r5rrr9v5.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r5rrr9v5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 10:49:50AM -0800, Eric W. Biederman wrote:
> Dimitri Sivanich <sivanich@sgi.com> writes:
> 
> > This patch allows for hard numa restrictions to irq affinity on x86 systems.
> >
> > Affinity is masked to allow only those cpus which the subarchitecture
> > deems accessible by the given irq.
> >
> > On some UV systems, this domain will be limited to the nodes accessible
> > to the irq's node.  Initially other X86 systems will not mask off any cpus
> > so non-UV systems will remain unaffected.
> 
> Is this a hardware restriction you are trying to model?
> If not this seems wrong.

Yes, it's a hardware restriction.
