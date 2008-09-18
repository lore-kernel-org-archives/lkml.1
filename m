Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbYIROb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbYIROb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYIRObw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:31:52 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:48900 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYIRObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:31:51 -0400
Message-ID: <48D2664D.7040204@freescale.com>
Date: Thu, 18 Sep 2008 09:31:41 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: dmaengine.c: question about device_alloc_chan_resources
References: <48D02589.8070601@freescale.com>	<e9c3a7c20809171536i189e3816x8572055d932c3c4c@mail.gmail.com>	<ed82fe3e0809180713v7e7a6115ya4612aa68879e39d@mail.gmail.com> <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080918162826.3a9d9429@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:

> Wouldn't it be better if the dmaengine layer made sure it didn't pass
> the same channel several times to a client?

Wouldn't that require it to keep track of which clients have already seen which
channels?  It might make more sense, but it's probably easier the current way.

-- 
Timur Tabi
Linux kernel developer at Freescale
