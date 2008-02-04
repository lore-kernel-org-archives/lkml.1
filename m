Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYBDULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYBDULW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYBDULM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:11:12 -0500
Received: from ip-224-2.sn2.eutelia.it ([83.211.224.2]:57313 "EHLO
	mail.retesintesi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757424AbYBDULK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:11:10 -0500
From: 4news@retesintesi.it
Organization: S.in.te.si. srl
To: scst-devel@lists.sourceforge.net
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 21:06:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802042106.11327.4news@retesintesi.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lunedì 4 febbraio 2008, Linus Torvalds wrote:
> So from a purely personal standpoint, I'd like to say that I'm not really
> interested in iSCSI (and I don't quite know why I've been cc'd on this
> whole discussion) and think that other approaches are potentially *much*
> better. So for example, I personally suspect that ATA-over-ethernet is way
> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and
> low-level, and against those crazy SCSI people to begin with.

surely aoe is better than iscsi almost on performance because of the lesser 
protocol stack:
iscsi ->  scsi - ip - eth
aoe -> ata - eth

but surely iscsi is more a standard than aoe and is more actively used by 
real-world .

Other really useful feature are that:
- iscsi is capable to move to a ip based san scsi devices by routing that ( 
i've some tape changer routed by scst to some system that don't have other 
way to see a tape).
- because it work on the ip layer it can be routed between long distance , so 
having needed bandwidth you can have a really remote block device spoking a 
standard protocol between non ethereogenus systems.
- iscsi is now the cheapest san avaible.

bye,
marco.

