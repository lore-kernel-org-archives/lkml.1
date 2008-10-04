Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYJDVvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYJDVvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYJDVvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:51:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49419 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753604AbYJDVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:50:59 -0400
Date: Sat, 4 Oct 2008 22:50:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Message-ID: <20081004225008.2cc08201@lxorguk.ukuu.org.uk>
In-Reply-To: <200810041213.22249.rjw@sisk.pl>
References: <200808290002.55026.rjw@sisk.pl>
	<200810032351.46869.rjw@sisk.pl>
	<20081004002724.47fab174@lxorguk.ukuu.org.uk>
	<200810041213.22249.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm, I'm not sure what you mean exactly, but the point is to blacklist the
> on-board controllers only and a devfn of the controller is needed for that,
> or a part of it (like the slot number I'm using).  Could that be done above
> the driver level?

It can be done in one place via the libata core code I think rather than
in each driver. Might need to be a helper function but you'd at least
remove all the duplication.

Alan
