Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbXGXRHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbXGXRHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXGXRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:06:54 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4200 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXGXRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:06:54 -0400
Message-ID: <46A631A1.6080002@shadowen.org>
Date: Tue, 24 Jul 2007 18:06:41 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53B70.1010903@intel.com> <Pine.LNX.4.64.0707241852510.18990@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707241852510.18990@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 23 2007 16:36, Kok, Auke wrote:
>> this somehow seems to match something completely non-related (a function
>> pointer declaration case):
>>
>> ERROR: no space between function name and open parenthesis '('
>> #7278: FILE: drivers/net/e1000e/hw.h:434:
>> +       bool (*check_mng_mode)(struct e1000_hw *);
>>
>> even if I put a space between ")(", it still complains.
> 
> [assumed] majority of kernel code uses ")(" instead of ")\s+(",
> so the warning seems bogus. And it even gets nitpicky.

Yep, thats just a false positive.  Will sort it out.

-apw
