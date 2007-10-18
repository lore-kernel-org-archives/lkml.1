Return-Path: <linux-kernel-owner+w=401wt.eu-S1765799AbXJRMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765799AbXJRMQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763186AbXJRMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:16:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:33548 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952AbXJRMQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:16:21 -0400
Subject: Re: [PATCH 2/3] ide: Fix siimage driver accessing beyond array
	boundary
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <47174B4A.3000006@ru.mvista.com>
References: <20071018005623.153C7DDEBD@ozlabs.org>
	 <47174B4A.3000006@ru.mvista.com>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 22:16:04 +1000
Message-Id: <1192709764.12879.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 16:02 +0400, Sergei Shtylyov wrote:
> Benjamin Herrenschmidt wrote:
> 
> > The siimage use an incorrect construct to access the other drive
> > of a pair, causing it to access beyond an array boundary on non-0
> > interfaces. This fixes it by using the new ide_get_paired_drive()
> > hepler instead.
> 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
>     Please update the driver version in the driver's heading comment. Otherwise
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

I don't believe much in driver versions in tree... the kernel version is
what matter... Bart, what's your stance there ?

Ben.


