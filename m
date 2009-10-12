Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbZJLTSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbZJLTSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbZJLTSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbZJLTSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:18:34 -0400
Date: Mon, 12 Oct 2009 15:37:40 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9 v3] KVM: Nested SVM fixes and tracepoint conversion
Message-ID: <20091012183740.GA13210@amt.cnet>
References: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255097313-23267-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 04:08:24PM +0200, Joerg Roedel wrote:
> Hi Avi, Marcelo,
> 
> this series of patches contains bugfixes for the Nested SVM code and the
> conversion of Nested SVM debugging to tracepoints. The fixes are:
> 
> 	1) A patch Alex already sent (1/9) but which was not yet
> 	   applied. It fixes a lost event_inj problem when we emulate a
> 	   vmrun and a vmexit without entering the guest in the
> 	   meantime.
> 
> 	2) The patch 2/9 fixes a schedule() while atomic bug in the
> 	   Nested SVM code. The KVM interrupt injection code runs with
> 	   preemtion and interrupts disabled. But the
> 	   enable_irq_window() function from SVM may emulate a #vmexit.
> 	   This emulation might sleep which causes the schedule() while
> 	   atomic() bug.
> 
> These fixes (patches 1 and 2) should also be considered for -stable
> backporting.  The patches 3 to 8 convert the old printk based debugging
> for Nested SVM to tracepoints.  Patch 9 removes the nsvm_printk code.
> Please review and/or consider to apply these changes.

Applied, thanks.

