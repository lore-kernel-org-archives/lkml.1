Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYEOKJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYEOKJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYEOKIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:08:51 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:45985 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYEOKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:08:50 -0400
Date: Thu, 15 May 2008 12:06:19 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, greg@kroah.com, fubar@us.ibm.com,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
Message-ID: <20080515120619.6c867bfb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080515.030054.247673168.davem@davemloft.net>
References: <20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
	<20080515.010139.219194657.davem@davemloft.net>
	<20080515113131.2cea2bce@gondolin.boeblingen.de.ibm.com>
	<20080515.030054.247673168.davem@davemloft.net>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 03:00:54 -0700 (PDT),
David Miller <davem@davemloft.net> wrote:

> No, the idea is that the __sysfs_add_one() wouldn't need a parameter
> at all.  sysfs_add_one() just needs to check for -EEXIST from
> __sysfs_add_one() to decide whether to warn or not.

But that is what the patch does? Only the upper layers need to pass a
flag around.
