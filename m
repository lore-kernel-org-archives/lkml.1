Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYISOfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYISOfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYISOe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:34:56 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:36946 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYISOez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:34:55 -0400
Message-ID: <48D3B880.3070607@freescale.com>
Date: Fri, 19 Sep 2008 09:34:40 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
References: <48D02589.8070601@freescale.com>	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com>	<20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>	<48D2664D.7040204@freescale.com>	<20080918164535.5e9f77a8@hskinnemo-gx745.norway.atmel.com>	<e9c3a7c20809182120r5e056dd7h170959dc1171af84@mail.gmail.com> <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080919132544.533ab7d0@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:

> Yes, or maybe provide an interface for simply requesting a channel
> without having to register any callbacks. 

I could use this feature.  The sound drivers for our MPC8610 processor use DMA,
but the drivers need to control the DMA hardware directly, so I can't use
dmaengine.  I would like to be able to just reserve the channels and program
them as I see fit.

-- 
Timur Tabi
Linux kernel developer at Freescale
