Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXGDFD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXGDFD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXGDFDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:03:00 -0400
Received: from ozlabs.org ([203.10.76.45]:37496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbXGDFC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:02:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.5690.908102.273897@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 13:38:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <200707032337.52544.rjw@sisk.pl>
References: <20070703211227.GA28758@srcf.ucam.org>
	<Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org>
	<20070703212002.GA28895@srcf.ucam.org>
	<200707032337.52544.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> Now, please tell me how many driver writers even thought that something
> might try to access their devices after .suspend() had been executed (or
> even whilie it was being executed)?

Well, I believe that the USB framework copes with this, except
possibly for some corner cases like the example that Alan Stern
posted.  The fact that powerbooks suspend and resume without the
freezer implies that the IDE framework, the console code and the
framebuffer code cope correctly (though possibly not all chipset
drivers).

So I think that a lot of the frameworks already get it right.  Of
course the quality of the low-level chipset drivers has always been
pretty variable. :)

Paul.
