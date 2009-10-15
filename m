Return-Path: <linux-kernel-owner+w=401wt.eu-S935375AbZJOTrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935375AbZJOTrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935366AbZJOTrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:47:19 -0400
Received: from claw.goop.org ([74.207.240.146]:48663 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935365AbZJOTrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:47:18 -0400
Message-ID: <4AD77C21.2050506@goop.org>
Date: Thu, 15 Oct 2009 12:46:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL RFC] pvclock cleanups and pvclock vsyscall support
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com> <4AD6C679.3000001@redhat.com>
In-Reply-To: <4AD6C679.3000001@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/09 23:51, Avi Kivity wrote:
>>   - Implement a pvclock vread function, so that pvclock-using
>> clocksources can be
>>     used by vsyscall/vdso vgettimeofday and vclock_gettime.
>>
>>   - Use pvclock vread in the Xen clocksource.
>>    
>
>
> Looks good to me.

Care to cook up a patch to implement the kvm bits to make sure it all
works OK for you?

Thanks,
    J
