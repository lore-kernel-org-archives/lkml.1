Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbZJMGlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbZJMGlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbZJMGlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146AbZJMGlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:41:13 -0400
Message-ID: <4AD420A4.7050508@redhat.com>
Date: Tue, 13 Oct 2009 08:39:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add	vsyscall	implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com>	<4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com>	<4ACFD43E.6000506@goop.org> <4AD0CDFB.9030704@redhat.com>	<4AD3738B.6050200@goop.org> <4AD375A5.8050205@redhat.com> <4AD37FE3.1010002@goop.org>
In-Reply-To: <4AD37FE3.1010002@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 09:13 PM, Jeremy Fitzhardinge wrote:
> On 10/12/09 11:29, Avi Kivity wrote:
>    
>> Good catch.  Doesn't that invalidate rdtscp based vgettimeofday on
>> non-virt as well (assuming p == cpu)?
>>      
> The tsc clocksource assumes the tsc is (mostly?) synced; it doesn't use
> rdtscp or make any attempt at per-cpu corrections.
>    

So it's broken or disabled when that assumption is wrong?  We could 
easily fix that now.  Might even reuse the pvclock structures.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

