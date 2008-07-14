Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYGNCM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYGNCM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYGNCMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:12:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52646 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYGNCMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:12:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, suresh.b.siddha@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
References: <1215989044.7549.219.camel@pasglop>
	<m1tzet2wie.fsf@frodo.ebiederm.org>
	<1215994659.7549.227.camel@pasglop>
	<20080713.174457.82768245.davem@davemloft.net>
Date: Sun, 13 Jul 2008 19:03:52 -0700
In-Reply-To: <20080713.174457.82768245.davem@davemloft.net> (David Miller's
	message of "Sun, 13 Jul 2008 17:44:57 -0700 (PDT)")
Message-ID: <m1ej5x1at3.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0154]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Multiple MSI, take 3
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> The x86 system designers decided to implement multi-MSI in an
> inconvenient way, it is not a "crap hardware design", merely
> some (unfortunately common) implementations of it happen to be.

To be clear I was referring to the PCI spec that describes multi-MSI
as a crap hardware design.

At the very least you are left with the problem of allocating multiple
contiguous destinations.  Which has the potential to create
fragmentation on all supported platforms.

Optional mask bits are also nasty.

My honest opinion is that the should have deprecated multi-msi after the
introduction of the msi-x specification.

Eric
