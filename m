Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbXIAQdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbXIAQdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 12:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXIAQdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 12:33:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:53470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbXIAQdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 12:33:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
Date: Sat, 1 Sep 2007 18:33:08 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       len.brown@intel.com, linux-ide@vger.kernel.org, dz@debian.org,
       minyard@acm.org, j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org,
       rlove@rlove.org, bzolnier@gmail.com, dmitry.torokhov@gmail.com,
       mzxreary@0pointer.de, stelian@popies.net, ibm-acpi@hmh.eng.br,
       ambx1@neo.rr.com, gimli@dark-green.com
References: <20070901142719.GA31990@havoc.gtf.org>
In-Reply-To: <20070901142719.GA31990@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011833.08581.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>     And if we're really lucky, this might enable some additional
>     optimizations on the part of the compiler.

Only if the kernel was compiled C++. C compilers generally ignore constness
for optimization purposes because it can be so easily casted away.

-Andi
