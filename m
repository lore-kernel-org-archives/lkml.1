Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbXITRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbXITRAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXITRAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:00:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbXITRAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:00:33 -0400
Message-ID: <46F2A72E.5010709@redhat.com>
Date: Thu, 20 Sep 2007 13:00:30 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with 2.6.23-rc6 on AMD Geode LX800
References: <639631.28356.qm@web51402.mail.re2.yahoo.com>
In-Reply-To: <639631.28356.qm@web51402.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 08:32 AM, Joerg Pommnitz wrote:
> Hello all,
> yesterday I tried to boot a kernel built from the current wireless-dev git tree (ath5k branch)
> on a MSEP800/A board (see http://www.milesie.co.uk/pdf/MSEP800.pdf). The board
> contains an AMD Geode LX800 CPU.
> The wireless-dev tree is up to date with Linus kernel 2.6.23-rc6.
> 
> Attached is a photographic screen shot. The EIP value of c0378dd6 seems to correspond with the
> reserve_bootmem_core from System.map:
> 
> c0378d51 t free_bootmem_core
> c0378da7 T free_bootmem
> c0378db2 T free_bootmem_node
> c0378dba t reserve_bootmem_core
> c0378e14 T reserve_bootmem
> c0378e1f T reserve_bootmem_node
> 

Can you post disassembled code for that function?
