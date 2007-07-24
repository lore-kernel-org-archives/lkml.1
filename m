Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXGXMye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXGXMye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXGXMy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:54:26 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:42970 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbXGXMyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:54:25 -0400
Date: Tue, 24 Jul 2007 14:54:33 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Greg KH" <gregkh@suse.de>, "Simon Arlott" <simon@fire.lp0.eu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs/udev broken in latest git?
Message-ID: <20070724145433.4848ada1@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
References: <46A59EAA.9030105@simon.arlott.org.uk>
	<20070724072540.GA835@suse.de>
	<20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	<20070724084654.GB13152@suse.de>
	<3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 11:20:02 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> It looks fine to me. "device" links must never point to anything else
> than a bus device.

Hm, but then
1. The patch sneaks this check in (the old code only checked for
   dev->parent)
2. The code is rather inconsistent now, since none of the other code
   paths check for dev->parent->bus...
