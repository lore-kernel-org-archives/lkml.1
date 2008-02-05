Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYBENFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYBENFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYBENFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:05:24 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3278 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYBENFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:05:23 -0500
Date: Tue, 5 Feb 2008 14:05:17 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Message-ID: <20080205130517.GA35763@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Vladislav Bolkhovitin <vst@vlnb.net>,
	Bart Van Assche <bart.vanassche@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mike Christie <michaelc@cs.wisc.edu>
References: <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org> <47A7986B.1070206@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7986B.1070206@garzik.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 05:57:47PM -0500, Jeff Garzik wrote:
> iSCSI and NBD were passe ideas at birth.  :)
> 
> Networked block devices are attractive because the concepts and 
> implementation are more simple than networked filesystems... but usually 
> you want to run some sort of filesystem on top.  At that point you might 
> as well run NFS or [gfs|ocfs|flavor-of-the-week], and ditch your 
> networked block device (and associated complexity).

Call me a sysadmin, but I find easier to plug in and keep in place an
ethernet cable than these parallel scsi cables from hell.  Every
server has at least two ethernet ports by default, with rarely any
surprises at the kernel level.  Adding ethernet cards is inexpensive,
and you pretty much never hear of compatibility problems between
cards.

So ethernet as a connection medium is really nice compared to scsi.
Too bad iscsi is demented and ATAoE/NBD inexistant.  Maybe external
SAS will be nice, but I don't see it getting to the level of
universality of ethernet any time soon.  And it won't get the same
amount of user-level compatibility testing in any case.

  OG.



