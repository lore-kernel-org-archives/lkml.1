Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZJNXkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZJNXkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbZJNXkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:40:13 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:35893 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762105AbZJNXkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:40:12 -0400
Message-ID: <4AD6611D.8040407@snapgear.com>
Date: Thu, 15 Oct 2009 09:39:09 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 5/6 RFC] arch/m68knommu/kernel/process.c: Remove the BKL
 from sys_execve
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain> <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain> <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain> <4AD45A06.2090606@snapgear.com> <alpine.LFD.2.00.0910141706070.9428@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910141706070.9428@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
> On Tue, 13 Oct 2009, Greg Ungerer wrote:
>> On 10/13/2009 08:34 AM, John Kacur wrote:
>>>> From e36c53d296132bc0ddbf6d9fb43ea5ea56dbd4a2 Mon Sep 17 00:00:00 2001
>>> From: John Kacur<jkacur@redhat.com>
>>> Date: Mon, 12 Oct 2009 23:37:28 +0200
>>> Subject: [PATCH] arch/m68knommu/kernel/process.c: Remove the BKL from
>>> sys_execve
>>>
>>> This looks like a copy-and-paste of functionality that no-longer needs the
>>> bkl.
>>> Just remove it.
>>>
>>> Signed-off-by: John Kacur<jkacur@redhat.com>
>> Tested and runs fine on m68knommu.
>>
>> Acked-by: Greg Ungerer <gerg@uclinux.org>
>>
>> Do you want me to push this into the m68knommu git tree,
>> for eventual merging into Linus' tree?  Or are you going
>> to push the whole set of patches together?
> 
> I'm collecting and pushing the BKL stuff, but if you want to take it
> just let me know and I drop it.

Would make more sense to keep it all together I think.
So you take it.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
