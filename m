Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZJ1J3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZJ1J3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZJ1J3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZJ1J3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:29:46 -0400
Date: Wed, 28 Oct 2009 10:29:01 +0100
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
	implementation
Message-ID: <20091028092900.GG3627@mothafucka.localdomain>
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default> <4AE739DA.20601@goop.org> <4AE7DC04.7080706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE7DC04.7080706@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 07:52:04AM +0200, Avi Kivity wrote:
> On 10/27/2009 08:20 PM, Jeremy Fitzhardinge wrote:
>> On 10/27/09 10:29, Dan Magenheimer wrote:
>>    
>>> Is there any way for an application to conclusively determine
>>> programmatically if the "fast vsyscall" pvclock is functional
>>> vs the much much slower gettimeofday/clock_gettime equivalents?
>>>
>>> If not, might it be possible to implement some (sysfs?)
>>> way to determine this, that would also be backwards compatible
>>> to existing OS's that don't have pvclock+vsyscall supported?
>>>
>>>      
>> It would probably be simplest and most portable for the app to just
>> measure the performance of gettimeofday and see if it meets its needs.
>>    
>
> How can you reliably measure performance in a virtualized environment?
If we loop gettimeofday(), I would expect the vsyscall-based version not to show
up in strace, right?
