Return-Path: <linux-kernel-owner+w=401wt.eu-S1750716AbXBKQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750716AbXBKQTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 11:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXBKQTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 11:19:34 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:34569 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbXBKQTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 11:19:33 -0500
Message-ID: <45CF4211.90808@gmail.com>
Date: Sun, 11 Feb 2007 17:19:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: KVM oops: killing interrupt handler
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com> <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com> <45CF3BF0.2070103@qumranet.com>
In-Reply-To: <45CF3BF0.2070103@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity napsal(a):
> Jiri Slaby wrote:
>> On 2/11/07, Avi Kivity <avi@qumranet.com> wrote:
>>> What guest? what host?  How to reproduce?
>>
>> It's intel core 2 duo emulating 32-bit wxp. It happened after
>> suspend/resume (he doesn't know if qemu was actually running) of the
>> machine.
>>
> 
> kvm suspend/resume support is only present in -mm (what's more, I don't 
> think in any released -mm).  A workaround is to rmmod kvm_intel before 
> suspending.

Aha, that would be the problem.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
