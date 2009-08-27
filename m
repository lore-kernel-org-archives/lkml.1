Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZH0IgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZH0IgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZH0IgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:36:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59548 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750761AbZH0IgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:36:14 -0400
Date: Thu, 27 Aug 2009 09:37:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Georgi Chulkov <g.chulkov@jacobs-university.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Mark Lord <liml@rtr.ca>
Subject: Re: ATA device reset, shoud I be concerned?
Message-ID: <20090827093701.24598b69@lxorguk.ukuu.org.uk>
In-Reply-To: <4A95F212.5060008@gmail.com>
References: <200801140019.20668.g.chulkov@jacobs-university.de>
	<20080115025435.1e21b703.akpm@linux-foundation.org>
	<20080115113552.75731bf8@lxorguk.ukuu.org.uk>
	<4794501E.90306@gmail.com>
	<20080121130256.2443d7c1@lxorguk.ukuu.org.uk>
	<47949AA4.9090601@gmail.com>
	<20080121141425.45aa9c61@lxorguk.ukuu.org.uk>
	<4794ACAF.70505@gmail.com>
	<4794AD3F.40309@gmail.com>
	<4A95F212.5060008@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nvidia CK804 SATA controllers appear to also explode on reading TF 
> registers after media errors in certain cases. (They tend to either 
> lockup the machine or throw HyperTransport timeout machine check 

You must halt any running DMA activity before reading them. This is true
for pretty much all task file style controllers although the results of
not doing so vary by device somewhat.

