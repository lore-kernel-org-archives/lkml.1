Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZJRIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZJRIoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZJRIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:44:17 -0400
Received: from claw.goop.org ([74.207.240.146]:55914 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZJRIoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:44:16 -0400
Message-ID: <4ADAD561.9060901@goop.org>
Date: Sun, 18 Oct 2009 17:44:17 +0900
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
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com> <4AD6C679.3000001@redhat.com> <4AD77C21.2050506@goop.org> <4ADAB8F4.6090502@redhat.com> <4ADACF48.9020907@goop.org> <4ADAD070.5080002@redhat.com>
In-Reply-To: <4ADAD070.5080002@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/09 17:23, Avi Kivity wrote:
>> On the other hand, there's nothing to stop us from moving to multiple
>> pages in future (either to support NUMA placement, or just more than 64
>> cpus).
>>    
>
> I'm already allocating multiple pages, so we'd just need to adjust the
> fixmap.

Are you changing pvclock_init_vsyscall() to allocate more pages?  More
fixmap slots should be no problem.

    J
