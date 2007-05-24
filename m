Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXEXXXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXEXXXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXEXXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:23:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXEXXXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:23:14 -0400
Message-ID: <46561E55.7090107@zytor.com>
Date: Thu, 24 May 2007 16:23:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Andi Kleen <ak@suse.de>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
References: <653FFBB4508B9042B5D43DC9E18836F5EE129C@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5EE129C@scsmsx415.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
> Yes. But it only has 3 features defined right now. 2 in EAX and one in
> ECX. Should I use 2 new words for these bits or just use the software
> defined bits as in my earlier patch?
> 

Oh for heaven's sake.  Could you please do the world a favour and shoot
your CPUID architect?

The real answer depends on how you expect it to grow in the future.
Intel has a piss-poor record at being consistent in this matter, which
speaks for a more ad hoc approach, but if there really is a sane growth
path going forward, then go ahead and define two new words.

	-hpa
