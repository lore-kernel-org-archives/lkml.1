Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbYBBTf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbYBBTf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYBBTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:35:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYBBTfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:35:47 -0500
Date: Sat, 2 Feb 2008 20:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Message-ID: <20080202193524.GC27927@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org> <20080202175738.GA26560@elte.hu> <47A4BB3C.6050709@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4BB3C.6050709@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

>> so i'm still totally befuddled why you think that there was anything 
>> particularly wrong or unhelpful about me replying to the specific 
>> pull request that introduced a particular breakage into the kernel. 
>> Had i mailed to lkml with a terse "kernel build broke" message with 
>> just an URL to a config and the build breakage, you could rightfully 
>> have complained that i should have done more to properly direct my 
>> bugreport. But this breakage was about a PCI API change, the pull 
>> request had a PCI mailing list Cc:-ed, why should i have thought that 
>> this needs the attention of any other parties?
>
> Because the change required knowledge not only of PCI, but of the 
> hardware in question.  As your patch demonstrated.
>
> And yes -- the original changes should have been CC'd to interested 
> parties as well.  I'm still waiting to hear back from Alan or Bart 
> whether the ATA/IDE changes in that PCI pile actually work...  the 
> original changeset even noted that relevant parties had not yet been 
> queried.

so please tell me Jeff. If Greg, who is the super-maintainer of your 
code area, and who deals with your code every day and changes it every 
minute and hour, simply did not Cc: the SCSI list - how am i, a largely 
outside party in this matter, supposed to notice that 3 maintainers and 
3 mailing lists in the Cc: were somehow not enough and that i was 
supposed to grow the already sizable Cc: list even more?

	Ingo
