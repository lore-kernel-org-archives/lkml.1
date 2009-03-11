Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZCKOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZCKOjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZCKOjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:39:32 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:52667 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZCKOjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:39:32 -0400
Message-ID: <49B7CD1B.2080704@mnementh.co.uk>
Date: Wed, 11 Mar 2009 14:39:23 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       akpm@linux-foundation.org
Subject: Re: [PATCH 03/05] tmio_mmc: Break out cnf area operations
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se> <20090311125911.1563.27785.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125911.1563.27785.sendpatchset@rx1.opensource.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:
> From:  Magnus Damm <damm@opensource.se>
> 
> Break out tmio_mmc io operations for the cnf area.
> This moves similar register operations into one place.

Not sure about this one yet. AFAICT this totally disables the HBA power 
control.

I'm wondering if this is a common problem.

It seems to me  that its likely that clock and power control are often 
external to the host controller chip. (not just on TMIO MMC).

I think it'd be a good idea if we came up with an infrastructre that 
allowed a set of clock / power control callbacks into the platform code.

Whats your use case for this? samee applies to the related cnf patch too.
