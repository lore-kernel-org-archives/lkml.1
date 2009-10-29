Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZJ2PH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZJ2PH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbZJ2PHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbZJ2PHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:07:55 -0400
Message-ID: <4AE9AFAE.5020306@redhat.com>
Date: Thu, 29 Oct 2009 17:07:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <6137c066-3dfd-49dd-bbf2-7718f8542958@default>
In-Reply-To: <6137c066-3dfd-49dd-bbf2-7718f8542958@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 04:46 PM, Dan Magenheimer wrote:
> No, the apps I'm familiar with (a DB and a JVM) need a timestamp
> not a monotonic counter.  The timestamps must be relatively
> accurate (e.g. we've been talking about gettimeofday generically,
> but these apps would use clock_gettime for nsec resolution),
> monotonically increasing, and work properly across a VM
> migration.  The timestamps are taken up to a 100K/sec or
> more so the apps need to ensure they are using the fastest
> mechanism available that meets those requirements.
>    

Out of interest, do you know (and can you relate) why those apps need 
100k/sec monotonically increasing timestamps?

-- 
error compiling committee.c: too many arguments to function

