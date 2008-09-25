Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYIYTXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYIYTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYIYTXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:23:14 -0400
Received: from khc.piap.pl ([195.187.100.11]:49134 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYIYTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:23:13 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       Andrew Morton <akpm@linux-foundation.org>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net>
	<9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
	<alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	<20080923.211215.193696086.davem@davemloft.net>
	<alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
	<21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
	<21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
	<alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
	<200809250401.54818.elendil@planet.nl>
	<Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 25 Sep 2008 21:23:11 +0200
In-Reply-To: <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz> (Jiri Kosina's message of "Thu\, 25 Sep 2008 19\:24\:57 +0200 \(CEST\)")
Message-ID: <m33ajovxls.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> Still, what confuses me a little bit -- the EEPROM of the card is set to 
> all 0xff, once the corruption happens. Isn't that a quite a coincidence, 
> that bytes representing "nothing" in this context are used?

Perhaps the entire chip has been erased with the "ERAL" (erase all)
command. Requires previously issued EWEN (erase/write enable).
Each command seems to require several writes to the EEPROM control
register.
-- 
Krzysztof Halasa
