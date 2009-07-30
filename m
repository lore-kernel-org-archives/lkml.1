Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZG3XEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZG3XEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZG3XEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:04:30 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47823 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZG3XEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:04:30 -0400
Message-ID: <4A7226FB.3070202@us.ibm.com>
Date: Thu, 30 Jul 2009 16:04:27 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain> <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain> <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain> <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain> <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain> <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain> <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain> <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <4A716E54.90105@klingt.org>
In-Reply-To: <4A716E54.90105@klingt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
> On 07/30/2009 02:48 AM, Thomas Gleixner wrote:
>>    Part of that semaphore rework is the RFC patch series I posted
>>    recently to get rid of the init_MUTEX[_LOCKED] irritation (minus
>>    the ones which turned out to be wrong)
> 
> this change breaks the compilation of the binary nvidia kernel module.
> in order to build the module, i need to apply the attached patch.

Please report this to nvidia.  They have accepted patches in the past 
for -rt support and have been reasonably easy to work with.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
