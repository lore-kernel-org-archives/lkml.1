Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZJ1Jeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZJ1Jeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZJ1Jeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZJ1Jef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:34:35 -0400
Message-ID: <4AE81011.4040904@redhat.com>
Date: Wed, 28 Oct 2009 11:34:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <4f079cd6-0872-4cb5-832b-ee6a46841192@default> <4AE739DA.20601@goop.org> <4AE7DC04.7080706@redhat.com> <20091028092900.GG3627@mothafucka.localdomain>
In-Reply-To: <20091028092900.GG3627@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2009 11:29 AM, Glauber Costa wrote:
>> How can you reliably measure performance in a virtualized environment?
>>      
> If we loop gettimeofday(), I would expect the vsyscall-based version not to show
> up in strace, right?
>    

Much better to have an API for this.  Life is hacky enough already.

-- 
error compiling committee.c: too many arguments to function

