Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0CNSWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 14:22:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56597 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0CNSWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 14:22:13 -0400
Message-ID: <4B9D294B.6050603@canonical.com>
Date: Sun, 14 Mar 2010 19:22:03 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Ben Hutchings <ben@decadent.org.uk>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, stable-review@kernel.org,
       Avi Kivity <avi@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [141/145] KVM: x86 emulator: Check CPL	level
 during privilege instruction emulation
References: <20100313002717.508317046@kvm.kroah.org>	<1268512677.2664.23.camel@localhost> <20100313221645.GA21225@suse.de>
In-Reply-To: <20100313221645.GA21225@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Mar 13, 2010 at 08:37:57PM +0000, Ben Hutchings wrote:
>> On Fri, 2010-03-12 at 16:27 -0800, Greg KH wrote:
>>> 2.6.32-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ----------------
>>> From: Gleb Natapov <gleb@redhat.com>
>>>
>>> commit e92805ac1228626c59c865f2f4e9059b9fb8c97b upstream.
>>>
>>> Add CPL checking in case emulator is tricked into emulating
>>> privilege instruction from userspace.
>> There were more security fixes released along with this, which surely
>> belong in a stable update:
>>
>> 1871c6020d7308afb99127bba51f04548e7ca84e KVM: x86 emulator: fix memory access during x86 emulation

This one caused a regression for AMD cpus. There is a patch for it in the
process but not upstream, yet.

>> f850e2e603bf5a05b0aee7901857cf85715aa694 KVM: x86 emulator: Check IOPL level during io instruction emulation
>> d4c6a1549c056f1d817e8f6f2f97d8b44933472f KVM: x86 emulator: Fix popf emulation
> 
> Yes, there were a number of kvm patches that I could not apply either
> because they did not apply, or because they caused build errors.  These
> are some of them.  I have asked the KVM developers to properly backport
> them as I know nothing about KVM.  Hopefully that will be done for the
> next round of stable releases.

I have done some backport work for 2.6.32 at least. This can be found at

git://kernel.ubuntu.com/smb/linux-2.6.32.y kvm

I have successfully booted a guest after the changes but it would surely help if
the KVM developers could give some review on the set.

Stefan
> thanks,
> 
> greg k-h
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review

