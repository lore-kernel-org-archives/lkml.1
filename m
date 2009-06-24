Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbZFXXdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbZFXXdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZFXXdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:33:15 -0400
Received: from fmailhost06.isp.att.net ([207.115.11.56]:60546 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZFXXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:33:15 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A42B7BC.2000402@lwfinger.net>
Date: Wed, 24 Jun 2009 18:33:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <1245845787.3093.3.camel@localhost.localdomain>	 <20090624112849.55b38fff@jbarnes-g45>	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>	 <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>	 <4A429DAA.3010303@lwfinger.net>	 <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>	 <4A42A2FD.1060401@lwfinger.net>	 <86802c440906241511i3d534723u4dfdef9448b54bb9@mail.gmail.com> <86802c440906241553j11c84adm45ef6e6e8f1fe10e@mail.gmail.com>
In-Reply-To: <86802c440906241553j11c84adm45ef6e6e8f1fe10e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jun 24, 2009 at 3:11 PM, Yinghai Lu<yhlu.kernel@gmail.com> wrote:
>> On Wed, Jun 24, 2009 at 3:04 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
>>> Yinghai Lu wrote:
>>> node 0 link 0: mmio [a0000, bffff]
>>> node 0 link 0: mmio [c0000000, dfffffff]
>>> node 0 link 0: mmio [e0000000, efffffff]
>>> node 0 link 0: mmio [f0000000, fe0bffff]
>>> bus: [00,ff] on node 0 link 0
>>> bus: 00 index 0 io port: [0, ffff]
>>> bus: 00 index 1 mmio: [a0000, bffff]
>>> bus: 00 index 2 mmio: [c0000000, fcffffffff]
>> that is read from pci config.
>>
>> and only one HT chain is there. so there is no point to use _CRS for them.
>>
>> please let me check if we could could have patch to deselect that.
>>
> 
> please try the attached patches.
> 
> applying sequence:
> fix_crs.patch
> use_pci_crs_early.patch
> 
> only_one.patch

>From what I read in Linus's mails, it may be a moot point; however, my
system boots with these 3, and only these 3, patches applied.

I didn't see any of the new printk's in the dmesg output.

Larry
