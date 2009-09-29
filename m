Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZI2KfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZI2KfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZI2KfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:35:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZI2KfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:35:10 -0400
Date: Tue, 29 Sep 2009 16:03:54 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090929103354.GA3766@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <20090922154549.GA11379@amit-x200.redhat.com> <20090929092431.GA3368@amit-x200.redhat.com> <200909291209.25775.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291209.25775.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Sep 29 2009 [12:09:25], Christian Borntraeger wrote:
> Am Dienstag 29 September 2009 11:24:31 schrieb Amit Shah:
> > OK; how I solved this is: a new internal message between the guest and
> > the host. If a host is a console port, the host has to indicate that by
> > passing a message to the guest and the guest then hooks it up with hvc.
> 
> I am curious how you going to make this compatible with existing code that 
> currently uses virtio console.

I've tested old qemu new kernel, new qemu old kernel, new qemu, new
kernel and all the cases work fine.

Please see the virtcons_probe() function for the details.

		Amit
