Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0CLRS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:18:29 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:51294 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab0CLRSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:18:23 -0500
Message-ID: <4B9A775D.5070303@pardus.org.tr>
Date: Fri, 12 Mar 2010 19:18:21 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr> <4B24856A.4020507@goop.org> <4B24BE17.805@pardus.org.tr> <4B2532A0.2070001@goop.org>
In-Reply-To: <4B2532A0.2070001@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> On 12/13/09 02:12, Ozan Çağlayan wrote:
>> Hmm, that's because we're using/developing a Linux distribution which
>> doesn't have 64-bit support yet. But since the guest will be a
>> compile-farm for our needs, it's worth trying to run an 64-bit distro on
>> the host to see the difference, thanks for the tip but how much should
>> this affect the performance?
> 
> 32-bit PAE is marginal above 4G of memory and the limit is at about 8G. 
> Above that, so much lowmem (<~1GB) is occupied by page and other kernel
> structures that there's barely any memory to do any real work.  If this
> is what's happening, you'd expect to see poor host performance, and slow
> guest performance would be secondary to that.

Updates on the issue after 3 months:
------------------------------------

The host is now running an x86_64 2.6.32.9 kernel with kvm-2.6.32.7 built as an external module.
The guest is 32-bit 2.6.32.9.

I've booted the guest with -smp 4 -m 4096

and I'm seeing the same slowness that I've mentioned in this thread during CUPS configuration.
I'll try to send kvm_stat output in this week and try the same configure on another guest OS to see if it differs or not.

I'm also thinking to build an optimized 2.6.33 for that rack server to see if things get better or not.

Thanks,
Ozan Caglayan
