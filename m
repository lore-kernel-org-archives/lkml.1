Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbXCRKYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbXCRKYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXCRKYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:24:51 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:26745 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXCRKYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:24:50 -0400
Date: Sun, 18 Mar 2007 11:22:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
Message-ID: <20070318102252.GA11201@osiris.ibm.com>
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FCCC39.7090104@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FCCC39.7090104@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 07:20:57AM +0200, Avi Kivity wrote:
> Heiko Carstens wrote:
> >On Sun, Mar 11, 2007 at 03:53:12PM +0200, Avi Kivity wrote:
> >  
> >>This patchset updates the kvm userspace interface to what I hope will
> >>be the long-term stable interface.  Provisions are included for extending
> >>the interface later.  The patches address performance and cleanliness
> >>concerns.
> > [...]
> >But the general question is: do you still plan to switch to a syscall
> >interface?
> 
> I don't have any present plans for that.  Maybe when the interface starts
> to evolve at a slower pace, or if it is shown to be significantly faster.
> 
> Not that interface stabilization here doesn't mean a freeze; it means that
> backwards compatibility starts when this gets merged.

If the interface is considered to be stable you can get rid of the
KVM_GET_API_VERSION ioctl, since the version can't change anymore, right?
