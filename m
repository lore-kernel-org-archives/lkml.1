Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbXK0IAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbXK0IAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXK0IAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:00:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbXK0IAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:00:25 -0500
Date: Tue, 27 Nov 2007 00:00:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "pchen" <pchen@nvidia.com>, "acurrid" <acurrid@nvidia.com>
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT
 platform
Message-Id: <20071127000008.1d4dc323.akpm@linux-foundation.org>
In-Reply-To: <200711251121.49585.prakash@punnoor.de>
References: <200711251121445151346@gmail.com>
	<200711251121.49585.prakash@punnoor.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 11:21:45 +0100 Prakash Punnoor <prakash@punnoor.de> wrote:

> Yay:

Sounds good.

> One thing I noticed in the patch:
> +		if (((bridge_dev = pci_find_slot(0, 0)) != NULL) &&
> 
> You rather want to use pci_get_bus_and_slot instead, as pci_find_slot is 
> deprecated.

yup.  I'll queue this to get it a bit of testing but won't send it to Greg,
in the expectation that an updated version will be prepared.

Please do feed the diff through scripts/checkpatch.pl too - there are a
large number of trivial coding-style glitches in there.


Also, your [patch 1/2] will break the build unless your [patch 2/2] is
applied.  This will break git bisection so please avoid it.  It is
appropriate to fold both these patches into a single one.

And please avoid sending multiple patches under the same title, as these
two were.

Thanks.
