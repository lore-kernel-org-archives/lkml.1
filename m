Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXCUKke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXCUKke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXCUKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:40:34 -0400
Received: from mx1.suse.de ([195.135.220.2]:48054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXCUKkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:40:33 -0400
From: Andi Kleen <ak@suse.de>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Date: Wed, 21 Mar 2007 11:37:09 +0100
User-Agent: KMail/1.9.1
Cc: Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       Stefan Prechtel <stefan.prechtel@googlemail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <200703211046.20724.ak@suse.de> <1174471808.10840.28.camel@localhost.localdomain>
In-Reply-To: <1174471808.10840.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211137.10884.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The BIOS/ACPI is broken and does only expose C1, which should not switch
> off LAPIC. The BIOS is switching into deeper C-States behind the kernels
> back somehow.

Hmm, perhaps we can check AMD && (cstate >= 2 || has a battery) ? 
Should be doable by looking up the battery object in ACPI

-Andi
