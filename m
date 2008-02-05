Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYBESI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYBESI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbYBESIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:08:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52669 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638AbYBESIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:08:31 -0500
Message-ID: <47A8A60B.7080000@garzik.org>
Date: Tue, 05 Feb 2008 13:08:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>,
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
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain> <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org> <47A7986B.1070206@garzik.org> <20080205130517.GA35763@dspnet.fr.eu.org>
In-Reply-To: <20080205130517.GA35763@dspnet.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Mon, Feb 04, 2008 at 05:57:47PM -0500, Jeff Garzik wrote:
>> iSCSI and NBD were passe ideas at birth.  :)
>>
>> Networked block devices are attractive because the concepts and 
>> implementation are more simple than networked filesystems... but usually 
>> you want to run some sort of filesystem on top.  At that point you might 
>> as well run NFS or [gfs|ocfs|flavor-of-the-week], and ditch your 
>> networked block device (and associated complexity).
> 
> Call me a sysadmin, but I find easier to plug in and keep in place an
> ethernet cable than these parallel scsi cables from hell.  Every
> server has at least two ethernet ports by default, with rarely any
> surprises at the kernel level.  Adding ethernet cards is inexpensive,
> and you pretty much never hear of compatibility problems between
> cards.
> 
> So ethernet as a connection medium is really nice compared to scsi.
> Too bad iscsi is demented and ATAoE/NBD inexistant.  Maybe external
> SAS will be nice, but I don't see it getting to the level of
> universality of ethernet any time soon.  And it won't get the same
> amount of user-level compatibility testing in any case.

Indeed, at the end of the day iSCSI is a bloated cabling standard.  :)

It has its uses, but I don't see it as ever coming close to replacing 
direct-to-network (perhaps backed with local cachefs) filesystems... 
which is how all the hype comes across to me.

Cheap "Lintel" boxes everybody is familiar with _are_ the storage 
appliances.  Until mass-produced ATA and SCSI devices start shipping 
with ethernet connectors, anyway.

	Jeff



