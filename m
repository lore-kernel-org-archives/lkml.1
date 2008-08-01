Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYHBAdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYHBAdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYHBAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:32:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26002 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYHBAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:32:54 -0400
Subject: Memory Power Management - Was: Re: [linux-pm] Ottawa Linux Power
	Management Summit, July 22, 2008 - Minutes
From: Igor Stoppa <igor.stoppa@nokia.com>
Reply-To: igor.stoppa@nokia.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808011704490.3011@localhost.localdomain>
References: <alpine.LFD.1.10.0807260205300.24819@localhost.localdomain>
	 <alpine.LFD.1.10.0808011704490.3011@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Maemo Software - Nokia Devices R&D
Date: Sat, 02 Aug 2008 02:50:17 +0300
Message-Id: <1217634617.28090.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 02 Aug 2008 00:32:31.0951 (UTC) FILETIME=[405155F0:01C8F437]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, 2008-08-01 at 17:05 -0400, ext Len Brown wrote:

[snip]

> Memory power management
> -----------------------
> 
> We discussed the challenges to memory power management
> on servers.  Specifically, power-friendly interleaving
> and the inability to migrate/free pages used by the kernel.
> 
> HSuperH may benefit soonest here b/c
> not stopped by interleaving issue.
> NUMA memory node for accounting.
> 
> Paul Mundt, using on SH
> needs to be dynamic b/c cores turned on/off dynamically.
> 
> This is a common requirement between embedded and server platform
> Consensus was to work on a common framework for page
> placement based on frequency of reference.
> 
> Physical address to memory module (DIMM) information needs to be
> exported by the platform to get started on any memory PM techniques.
> Currently there is no information about fine grain memory topology
> except for NUMA systems at node level.

I am interested about the embedded part: last year Nokia had an
evaluation done on the memory chip used for n800, which can be set to
perform self refresh of 1/4, 1/2 and 1/1 of the available SDRAM.

The finding was that on average the energy spent for rearranging the
pages so that those going to be preserved would be in the memory area
kept in self refresh + the energy spent for reloading the other pages
from flash was significantly higher than just using self refresh for the
entire SDRAM.

I can dig out the details if there is interest, however the SDRAM used
is the mobile type with relatively low leakages and speed (133MHz).

I'd be interested to know what's the case with SH and if there has been
any study/verification.

-- 

Cheers, Igor

---

Igor Stoppa
Maemo Software - Nokia Devices R&D - Helsinki
