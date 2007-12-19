Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXLSRKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXLSRKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXLSRJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:09:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:38796 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbXLSRJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:09:50 -0500
Message-ID: <4769505C.5020309@qumranet.com>
Date: Wed, 19 Dec 2007 19:09:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dor.laor@qumranet.com
CC: Amit Shah <amit.shah@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@argo.co.il>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernelsprior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <47692A47.4040803@argo.co.il><5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com> <200712192225.53748.amit.shah@qumranet.com> <47694F35.6070401@qumranet.com>
In-Reply-To: <47694F35.6070401@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dor Laor wrote:
>> > >
>> > > vmx (and svm) allow us to add an offset to the physical tsc.  We 
>> set it
>> > > on startup to -tsc (so that an rdtsc on boot would return 0), and
>> > > massage it on vcpu migration so that guest rdtsc is monotonic.
>> > >
>> > > The net effect is that tsc on a vcpu can experience large forward 
>> jumps
>> > > and changes in rate, but no negative jumps.
>> >
>> > Changes in rate does not sound good. It's possibly what's screwing up
>> > my paravirt clock implementation in smp.
>>
>> Do you mean in the case of VM migration, or just starting them on a 
>> single
>> host?
>>
> It's the cpu preemption stuff on local host and not VM migration

No, migrating a vcpu to another cpu.

-- 
error compiling committee.c: too many arguments to function

