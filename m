Return-Path: <linux-kernel-owner+w=401wt.eu-S1750829AbXCULHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829AbXCULHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXCULHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:07:17 -0400
Received: from www.osadl.org ([213.239.205.134]:51448 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750829AbXCULHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:07:16 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andi Kleen <ak@suse.de>
Cc: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <200703211137.10884.ak@suse.de>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211046.20724.ak@suse.de>
	 <1174471808.10840.28.camel@localhost.localdomain>
	 <200703211137.10884.ak@suse.de>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 12:14:26 +0100
Message-Id: <1174475666.10840.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 11:37 +0100, Andi Kleen wrote:
> > The BIOS/ACPI is broken and does only expose C1, which should not switch
> > off LAPIC. The BIOS is switching into deeper C-States behind the kernels
> > back somehow.
> 
> Hmm, perhaps we can check AMD && (cstate >= 2 || has a battery) ? 
> Should be doable by looking up the battery object in ACPI

Which makes us rely on another ACPI feature. What guarantees that the
ACPI tables are correct for this one ?

	tglx


