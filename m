Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZGPTjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZGPTjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932415AbZGPTjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:39:02 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:39602 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932454AbZGPTjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:39:00 -0400
Message-ID: <4A5F81BF.5000301@acm.org>
Date: Thu, 16 Jul 2009 13:38:39 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, glommer@redhat.com,
       aliguori@us.ibm.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <200907161852.42071.arnd@arndb.de> <4A5F6FF4.2090706@novell.com> <4A5F773C.2020303@novell.com>
In-Reply-To: <4A5F773C.2020303@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090716/1MRWmu-0005Jl-3s-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Gregory Haskins wrote:
>> Note that if we are going to generalize the interface to support other
>> guests as you may have been suggesting above, it should probably stay
>> statically linked (and perhaps live in ./lib or something)
>>   
> 
> More specifically, it can no longer live in kvm.ko.  I guess it
> technically doesn't have to be statically linked, though (e.g.
> xinterface.ko is fine, too).

Speaking as someone who knows nothing about this, if this is going to be 
a module and visible in places like lsmod, could you name it something else?

I see "xinterface.ko" and the first thing in my head is "something to do 
with the X Window System."

How about kvm_xinterface or vguest_xinterface?

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
