Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZJFG5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZJFG5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZJFG5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbZJFG5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:57:00 -0400
Date: Tue, 6 Oct 2009 12:25:46 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20091006065546.GA25410@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200910011228.30563.borntraeger@de.ibm.com> <20091005140535.GA31333@amit-x200.redhat.com> <200910060849.22462.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910060849.22462.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Oct 06 2009 [08:49:22], Christian Borntraeger wrote:
> Am Montag 05 Oktober 2009 16:05:35 schrieb Amit Shah:
> > On (Thu) Oct 01 2009 [12:28:30], Christian Borntraeger wrote:
> > > With the latest git kernel + your patch I sometmes get a completely
> > > frozen console. In the dump there is
> > >
> > >     <3>virtio_console virtio0: output:id 68 is not a head!
> > >
> > > Seems that I can reproduce it with large amounts of output (find / for
> > > example) Without your patch everything is fine.
> > 
> > Hey Christian,
> > 
> > Can you try this patch?
> 
> This version seems to work on s390. Thanks

Great; thanks for the confirmation.

The race I'm seeing could be due to some misconfiguration in qemu then.

		Amit
