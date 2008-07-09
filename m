Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYGIOkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYGIOkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYGIOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:39:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53297 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753575AbYGIOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:39:57 -0400
Message-ID: <4874CDBC.6010500@sgi.com>
Date: Wed, 09 Jul 2008 07:39:56 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com> <m1r6a4c5im.fsf@frodo.ebiederm.org> <4873FD00.1060101@goop.org>
In-Reply-To: <4873FD00.1060101@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>> Mike Travis <travis@sgi.com> writes:
>>
>>  
>>> Unfortunately it's back to the problem of faulting before
>>> x86_64_start_kernel()
>>> and grub just immediately reboots.  So I'm back at analyzing
>>> assembler and
>>> config differences.
>>>     
>>
>> Ok.  That is a narrow window of code.  So it shouldn't be too bad,
>> nasty though.
>>
>> If you would like to trace through it I have attached my serial port
>> debugging routines that I use in that part of the code.
> 
> Last time it was doing this, it was a result of a triple-fault caused by
> loading %ds with an all-zero gdt.  I modified Xen to dump the CPU state
> on triple-faults, so it was easy to pinpoint.  I can do that again if it
> helps.
> 
>    J

Absolutely!  I'll repost the latest version of the patchset.  Still haven't
gotten around to enabling a XEN boot but it sure does sound handy.

Thanks,
Mike
