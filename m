Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZK3IPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZK3IPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZK3IPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:15:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZK3IPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:15:11 -0500
Message-ID: <4B137F10.906@redhat.com>
Date: Mon, 30 Nov 2009 10:15:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b
 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>	<87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com> <87y6lorjq6.fsf@spindle.srvr.nix>
In-Reply-To: <87y6lorjq6.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 01:31 AM, Nix wrote:
> On 29 Nov 2009, Avi Kivity stated:
>    
>> Most likely, either this or something similar is called on a userspace
>> device driver.  Can you check if this is triggered by starting X?
>>      
> *sigh* I just wasted twenty minutes trying to find some way, *any* way
> to not start X under Ubuntu Karmic, so as to test this. None is evident.
> I can't even figure out what and where in upstart's horrific dependency
> tangle is starting X in the first place: deleting suspicious-looking
> things from rc*.d has no effect at all. I can't even tell if rc*.d is
> still used, nor if the concept of runlevel is even meaningful any
> longer. There are lots of things googleable that claim to say how to do
> this, but all relate to the non-dependency-based inittab-emulating
> method used in previous Ubuntu versions.
>
> Anyone know?
>    

At least on Fedora, you you can change the runlevel in /etc/inittab (the 
sole remaining function of the file).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

