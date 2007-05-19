Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbXESR0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbXESR0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXESR0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:26:07 -0400
Received: from dedi.luli.de ([88.198.62.74]:42883 "EHLO dedi.luli.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXESR0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:26:07 -0400
Message-ID: <464F332C.8060904@rootdir.de>
Date: Sat, 19 May 2007 19:26:04 +0200
From: Claas Langbehn <claas@rootdir.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Christian Volkmann <haveaniceday@cv-sv.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64 II
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de>
In-Reply-To: <464EE2AA.3030607@cv-sv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Volkmann wrote:
> Hi Andi,
>
> your patch did not work. See the correction below. The mask should contain 1<<1
> instead of 1.
> Model 10 is now also included.
>
> I add also a patch for setup.S. It does not print the CPUID message in case
> the CPUID is wrong, cause %ds was not set proper.
>
>   
Hello Christian,

do you know if and how it's possible to enable NX_bit too?


Claas
