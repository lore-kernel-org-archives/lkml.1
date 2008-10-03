Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYJCX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYJCX2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYJCX2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:28:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45280 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbYJCX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:28:14 -0400
Date: Sat, 4 Oct 2008 00:27:24 +0100
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
Message-ID: <20081004002724.47fab174@lxorguk.ukuu.org.uk>
In-Reply-To: <200810032351.46869.rjw@sisk.pl>
References: <200808290002.55026.rjw@sisk.pl>
	<200810031703.32114.rjw@sisk.pl>
	<200810032348.59709.rjw@sisk.pl>
	<200810032351.46869.rjw@sisk.pl>
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

> in the final phase of hibernation.  In particular, some SATA drivers
> are going to use it for blacklisting systems in which the disks
> should not be spun down during the last phase of hibernation (the
> BIOS will do that anyway).

If you added the PCI ids for the controller to your tables you could
implement this series once instead of in multiple drivers

