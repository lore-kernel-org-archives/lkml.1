Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXKJUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXKJUX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXKJUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:23:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbXKJUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:23:17 -0500
To: Jan Glauber <jang@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Module init call vs symbols exporting race?
From: Andi Kleen <andi@firstfloor.org>
References: <473031FA.2060707@openvz.org>
	<200711062341.34566.rusty@rustcorp.com.au>
	<1194429690.6874.7.camel@localhost.localdomain>
Date: Sat, 10 Nov 2007 21:23:08 +0100
In-Reply-To: <1194429690.6874.7.camel@localhost.localdomain> (Jan Glauber's message of "Wed\, 07 Nov 2007 10\:01\:30 +0000")
Message-ID: <p73ejex26kz.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Glauber <jang@linux.vnet.ibm.com> writes:

> I've seen a symbol-resolving race on s390. The qeth module uses symbols
> from qdio and although the loading order seems correct and the qdio
> symbols should be available the following error appears:

FWIW i see such messages all the time with usb serial on my workstation too.
It's not new.

For some reason it never makes it to the log file though, i only see
it flashing by on the console.

-Andi

