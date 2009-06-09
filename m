Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZFIIUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZFIIUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbZFIIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:20:15 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53121 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759335AbZFIIUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:20:13 -0400
Date: Tue, 9 Jun 2009 16:14:31 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090609081431.GA25316@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org> <alpine.LFD.2.01.0906041038130.4880@localhost.localdomain> <200906060717.46964.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906060717.46964.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 07:17:44AM -0500, Michael S. Zick wrote:
> The mainstream kernel, e_powersaver, is *under-clocking* my machine -
> 
> The cpuid instruction provides the minimum and maximum GSF values 
> (Guaranteed Stable Frequency) for that processor mask run -
> Passing that on as the lower and upper limits to e_powersaver should
> stop that problem.  Will be testing this RSN.

Can you provide more information on where you think you are getting the GSF
values from?  I am not aware of such information.

The internal documentation always only refres to the minimum VID/FID values
from the MSR.  Also, according to the specifications of all C7 models listed,
there are some that require a minimum of 400MHz, others require a minimum of
800.  I have not found any that would require a minimum of 600MHz.

So I don't really know if your system really operates outside any specified
range.

The only thing I know of that you can read from the CPUID vendor string is
the maximum clock frequency in ASCII.

So it seems, e_powersaver is not really at all as dangerous as it appeared!

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
