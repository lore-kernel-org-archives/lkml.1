Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbXJVKGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbXJVKGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXJVKGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:06:10 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2534 "EHLO
	iamp04-out.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751162AbXJVKGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:06:09 -0400
Message-ID: <471C75E7.2070400@draigBrady.com>
Date: Mon, 22 Oct 2007 11:05:27 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about free/used memory on Linux
References: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC3024B847B@xmb-sjc-214.amer.cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Oct 2007 10:07:07.0682 (UTC) FILETIME=[4DB9A820:01C81493]
X-CTCH-RefID: str=0001.0A0B0201.471C75AE.0057,ss=1,fgs=0
X-MXUniqueID: 099cb6e7-af0f-41fd-85b8-b1c83472b340
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ravinandan Arakali (rarakali) wrote:
> Hi kernel gurus,
> I am trying to find out the memory that's used on my linux box.
> I find that there are quite a few confusing metrics. How do
> I find out the "true" used memory ?
> 
> 1. For eg. "free -m" shows free memory (excluding buffers/caches) 
> as 308 MB while I can see(from "df" output) that the the tmpfs 
> partitions take up about 400 MB. So, does "free -m" not consider 
> the tmpfs partitions ?
> 
> 2. I try to add up RSS field of all processes reported by
> "ps aux" command. But is it true that this would be misleading
> in that, shared memory used by, say 2 processes would show
> up twice here although there's only one copy in memory. Also
> does this consider the fact that there's only one copy
> of shared libraries ?

Have a look at this script so show RAM used by programs:
http://www.pixelbeat.org/scripts/ps_mem.py

Note to display totals you will need this patch applied:
http://lkml.org/lkml/2007/8/13/1224

Pádraig.
