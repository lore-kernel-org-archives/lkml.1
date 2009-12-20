Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZLTUGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZLTUGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZLTUGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:06:13 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33691 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZLTUGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:06:12 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20091219358.549678091@firstfloor.org>
	<20091219145832.A0424B158A@basil.firstfloor.org>
	<alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
	<20091219211831.GA19716@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Dec 2009 12:06:02 -0800
In-Reply-To: <20091219211831.GA19716@basil.fritz.box> (Andi Kleen's message of "Sat\, 19 Dec 2009 22\:18\:31 +0100")
Message-ID: <m1d429o1g5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] [1/2] SYSCTL: Make bin_table not const
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Sat, Dec 19, 2009 at 09:40:56AM -0800, Linus Torvalds wrote:
>> 
>> 
>> On Sat, 19 Dec 2009, Andi Kleen wrote:
>> > 
>> > Turn all the bin_tables from const to non-const. This is needed for the next
>> > patch. Unfortunately there were a lot of them, so the patch is rather 
>> > large, but it is completely mechanic. 
>> 
>> Ouch. I hate this.
>> 
>> I'd much rather have a constant sysctl bin_table.
>
> Understood. I'll poke at that and try to come up with a tested patch
> tomorrow or so.

Is printk_ratelimit truly ineffective at what it does?

Arguably we don't need to warn anywhere near that often, so even
if printk_ratelimit works we are good.

If printk_ratelimit let's too much through we really should also write
a patch to let fewer messages through that way.

Eric
