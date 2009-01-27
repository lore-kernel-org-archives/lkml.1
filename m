Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZA0SMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZA0SMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZA0SMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:12:35 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48741 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872AbZA0SMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:12:34 -0500
Message-ID: <497F4E59.5040605@euromail.se>
Date: Tue, 27 Jan 2009 19:11:37 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rydberg@bitmath.org,
       torvalds@linux-foundation.org, mjg@redhat.com, nicolas@boichat.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 18/19] Define MODULE_SYSTEM_TABLE for mbp_nvidia_bl.o
 and applesmc.o
References: <200812092114.mB9LETsI027215@imap1.linux-foundation.org>	<493F1C96.5070400@bitmath.org>	<200812120305.mBC35vh8078366@www262.sakura.ne.jp>	<20081212042503.GA14668@x200.localdomain> <20090126225909.0937356c.akpm@linux-foundation.org>
In-Reply-To: <20090126225909.0937356c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LRsPy-0006nI-9b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LRsPy-0006nI-9b 2d672a0ef541ddfe92cc6240f69bcfc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Dec 2008 07:25:03 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
>>> -MODULE_DEVICE_TABLE(dmi, applesmc_whitelist);
>>> +MODULE_SYSTEM_TABLE(dmi, applesmc_whitelist);
>> I sent patch which does "#define dmi_device_id dmi_system_id" and thus
>> avoids yet another wrapper.
> 
> What was the fate of this patch?
> 
> If it's still needed, please resend.

I'll send David's minipatch to you shortly, for piece of mind.

Thanks,
Henrik
