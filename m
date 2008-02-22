Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYBVJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYBVJgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYBVJgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:36:07 -0500
Received: from smtp-3.orange.nl ([193.252.22.243]:36009 "EHLO smtp-3.orange.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYBVJgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:36:04 -0500
X-ME-UUID: 20080222093601617.96A961C00081@mwinf6208.orange.nl
Message-ID: <47BE9781.3030304@zonnet.nl>
Date: Fri, 22 Feb 2008 10:36:01 +0100
From: belcampo <belcampo@zonnet.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hyperthreading performance oddities
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would like to be personally CC'ed the answers/comments posted to the 
list in response to my posting.

I have following CPU
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
stepping        : 1
cpu MHz         : 3000.000
cache size      : 1024 KB

on 2.6.17 everything works as I expect. My Mandriva distribution 
standard has a 2.6.22.9 kernel which performed bad, numbers follow, 
installed a fresh 2.6.24.2 kernel also performed bad, so I installed 
2.6.17 and everything works OK.
I have some benchmarks from mplayer:
Kernel 2.6.22.9 smp hyperthreading
BENCHMARKs: VC: 334.042s VO:   0.053s A:   0.000s Sys:   4.049s =  338.143s
Kernel 2.6.22.9 nonsmp/hyperthreading
BENCHMARKs: VC: 262.008s VO:   0.031s A:   0.000s Sys:   3.528s =  265.567s
with 2.6.17 kernel smp/hyperthreading pentium-pro as CPU
BENCHMARKs: VC: 245.175s VO:   0.050s A:   0.000s Sys:   2.479s =  247.704s
with 2.6.17 kernel smp/hyperthreading pentium4 optimized kernel
BENCHMARKs: VC: 227.992s VO:   0.051s A:   0.000s Sys:   2.551s =  230.594s

The 2.6.24.2 kernel had results as the 2.6.22.9 version

Regards Henk Schoneveld

