Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZG1TuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZG1TuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZG1TuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:50:09 -0400
Received: from claw.goop.org ([74.207.240.146]:47884 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZG1TuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:50:09 -0400
Message-ID: <4A6F5670.4010405@goop.org>
Date: Tue, 28 Jul 2009 12:50:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stefan Assmann <sassmann@suse.de>
Subject: drivers/pci/quirks.c: irq_reroute_variant is dead code?
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quirk_reroute_to_boot_interrupts_intel() goes to some effort to scan for
a bunch of Intel devices and set dev->irq_reroute_variant =
INTEL_IRQ_REROUTE_VARIANT.  However, as far as I can see that's the only
reference to dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so
the whole thing appears to have no effect.

Is it all dead code?  Is there something else which should be there missing?

Thanks,
    J
