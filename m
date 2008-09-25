Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYIYQ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYIYQ0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYIYQ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:26:31 -0400
Received: from khc.piap.pl ([195.187.100.11]:57021 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYIYQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:26:30 -0400
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net>
	<9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
	<alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	<20080923.211215.193696086.davem@davemloft.net>
	<alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
	<21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
	<48DB12C9.5080104@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 25 Sep 2008 18:26:27 +0200
In-Reply-To: <48DB12C9.5080104@gmail.com> (Jesse Brandeburg's message of "Wed\, 24 Sep 2008 21\:25\:45 -0700")
Message-ID: <m38wtgw5sc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Brandeburg <jesse.brandeburg@gmail.com> writes:

> I'm really sorry to hear that, I wonder if the laptop has an
> "emergency bios update" mode like many PCs used to through a jumper.
> Dave A., let us know if you make any recovery progress.

I guess it's more about the E1000's serial configuration EEPROM, the
registers seem to live in BAR0 (EECD and for reading perhaps EERD).
Corrupted EEPROM (and thus PCI config registers) can easily result in
a dead machine.

I will be writing a tool for writing 82541PI EEPROMs on a custom
board soon (unless there is one available, for Linux, of course),
I only have to fight non-working JTAG first :-)

> I plan to try some random writes tomorrow to my BAR1 space and see if
> my flash gets erased.

I'm not sure it's the flash that is corrupted. Anyway booting the
laptop should be quite easy (physically disabling the EEPROM on boot
should do the trick), though it would require taking the machine
apart.
-- 
Krzysztof Halasa
