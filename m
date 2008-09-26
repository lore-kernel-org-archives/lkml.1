Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbYIZTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbYIZTl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbYIZTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:41:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39078 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbYIZTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:41:18 -0400
Date: Fri, 26 Sep 2008 20:39:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       airlied@gmail.com, Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Message-ID: <20080926203933.4e0cd071@lxorguk.ukuu.org.uk>
In-Reply-To: <m38wten3dj.fsf@maximus.localdomain>
References: <20080923.150722.141587696.davem@davemloft.net>
	<200809251156.10648.jbarnes@virtuousgeek.org>
	<alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
	<200809251236.12287.jbarnes@virtuousgeek.org>
	<alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
	<48DC176E.6020807@zytor.com>
	<m38wten3dj.fsf@maximus.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> external BMC (TCO) (loaded by external BMC from the SMBus) and one for
> software only (not used by hardware). Some chips only support #1 (and
> #4 of course).

We have had historic problems where a very non standard EEPROM setup on
some ancient thinkpads ended up with bad stuff happening due to smbus
probing and the like. You would then however expect to see the bug occur
without loading the e1000* drivers (unless you needed an interaction
between the two)

