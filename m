Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXCSQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXCSQjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030383AbXCSQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:39:43 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:55875 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030358AbXCSQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:39:42 -0400
Date: Mon, 19 Mar 2007 17:37:54 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Avi Kivity <avi@argo.co.il>, Anthony Liguori <aliguori@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
Message-ID: <20070319163754.GC8331@osiris.boeblingen.de.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com> <20070316150145.GB8525@osiris.boeblingen.de.ibm.com> <45FD1778.6030602@argo.co.il> <20070319154311.GB8331@osiris.boeblingen.de.ibm.com> <45FEB431.8030504@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FEB431.8030504@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 06:02:57PM +0200, Avi Kivity wrote:
> Heiko Carstens wrote:
> I agree with all of the above, and in addition, integration to the
> scheduler will allow us to reduce vcpu migration rate, and maybe do
> things like gang scheduling.
> 
> But that doesn't mean it can be done now: we really need to see how it
> works out with smp and with an additional arch, and then we can stabilize
> it.  Meanwhile I'd like a stable ABI so distros can start shipping
> kvm without worrying about upgrade headaches.
> 
> So the plan is:
> - get the /dev/kvm ABI into 2.6.22
> - implement smp
> - add another arch
> - move to a syscall based interface in parallel; userspace should work with both
> - deprecate the old ABI and external modules.

I wasn't asking to change the ABI right now, just wanted to make sure that
it is not the 'final' interface. So I agree with your plan.
