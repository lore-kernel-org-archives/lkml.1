Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXHTW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXHTW04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHTW0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:26:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:57985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbXHTW0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:26:46 -0400
In-Reply-To: <20070820213554.2885D4D05F4@magilla.localdomain>
References: <20070820213554.2885D4D05F4@magilla.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <68407da7522641faaaf9df0e2deeef98@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] Fix for assembler -g
Date: Tue, 21 Aug 2007 00:26:41 +0200
To: Roland McGrath <roland@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> In a way though, good thing, or mainline would have continued to be
>>> broken :)
>>
>> What do I need to do to see this bug, btw?  A special config
>> symbol perhaps?
>
> CONFIG_DEBUG_INFO=y
> and pass-g-to-assembler-under-config_debug_info.patch from -mm

Ah, an -mm patch.  Gotcha.

The fix most likely won't be necessary anymore for .24, since all
of lparmap.s will be gone -- see patch earlier today to linuxppc-dev.
Good riddance :-)


Segher

