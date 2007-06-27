Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbXF0O6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbXF0O6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbXF0O6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:58:40 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:53845 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761733AbXF0O6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:58:39 -0400
Message-ID: <468277D8.4030508@aitel.hist.no>
Date: Wed, 27 Jun 2007 16:44:40 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: =?UTF-8?B?Wm9sdMOhbiBIVUJFUlQ=?= <zoltan.hubert@zzaero.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <200706261637.22820.zoltan.hubert@zzaero.com> <6FD45914-1793-45D5-B0A1-F5D32ED38017@e18.physik.tu-muenchen.de> <200706271118.36985.zoltan.hubert@zzaero.com>
In-Reply-To: <200706271118.36985.zoltan.hubert@zzaero.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltán HUBERT wrote:
> Thanks Roland,
>
> On Tuesday 26 June 2007 21:03, Roland Kuhn wrote:
>   
>> On 26 Jun 2007, at 16:37, Zoltán HUBERT wrote:
>>     
>>> Whatever "stable" means.
>>>       
>> What you mean by "stable" pretty much excludes any
>> serious development, without which the Linux kernel would
>> very soon be obsolete. If you want a stable system, then
>> don't change it. 
>>     
>
> This is a problem. Do you remember that kernel vulnerability 
> in 2.4 that made the Debian servers be attacked ? And 
> mplayerhq.hu too if I remember right ? So what are we 
> supposed to do with a perfect and optimised system, running 
> smoothly, with an older kernel where some nasty bug is 
> discovered ?
>
> In MacOS X, you click "System Update" and you're done. 
>
> In Linux, I expect "download the newest stable kernel, 
> configure, compile, install, reboot". 
>   
Correct.

Just be aware of this:
If you use a binary-only driver, then you have an unsupported
configuration.  Unsupported by the kernel community at least.
So no support, and if it breaks - you keep the pieces.

You bring up MacOS X.  The same problem exists there.
If a third party makes a strange closed driver that do all
sorts of things apple says a driver shouldn't, then this
driver may very well break on the next "System Update".

Now, perhaps there aren't any such strange drivers for MacOS X,
perhaps all vendors figured out that it is smarter to
cooperate with apple and follow their rules when making
drivers.

Similiar guidelines and rules exist for linux driver development.
And one of the important rules is: post the driver to the kernel
list. Clean it up and maintain it until it gets merged. Then it
is a supported driver, and some care will be taken not to break it.

But some vendors just have to go and make an unsupportable
driver instead - all closed-source drivers fall into this category.
So those drivers are unsupported.
The kernel community advice against using them (they could
make your linux kernel unstable, and nobody but the
vendor can then help.)
If such a driver breaks on a kernel upgrade then
sure - "it is not our problem".  Just as it isn't apple's
problem if a unsupported mac osx driver breaks, just
as it isn't microsoft's problem if a third party driver breaks
because it was made against all guidelines.

Microsoft offer driver certification for vendors that want to
avoid this kind of problems. Linux has a similiar arrangement.
The "certification" equivalent is to get the driver merged
into the kernel source. Open source is but one requirement
for this to happen. Code quality is another.
> If I have to rely on the distribution to help me it spoils 
> the whole benefit of open source. I don't trust Novell or 
> RedHat or Google more than Microsoft or Apple. You "kernel 
> developpers" are the keepers of the flame.
>   
>> If you update to a kernel which is 2.5 
>> years newer, you simply cannot have stability, because
>> that would mean stagnation, aka "death".
>>     
>
> PostScript is a very old language yet we all still use it 
> every day. HTML is a very old "thing" and we use it 
> every-day, and it's still compatible with newer and older 
> stuff.
>
> I'm a system engineer, and a "stable" system is one where 
> the interfaces are stable. Individual components can 
> change, and do change, but if you change fundamental 
> interfaces it is not the same system. Of course I 
> understand that "sometimes" fundamental things have to 
> change, but here "sometimes" is the keyword. If its 
> "anytime" it simply is no stable system. And yes, designing 
> and maintaining interfaces is a very difficult job.
>   
Linux is stable then. The kernel component offer an unchanging
interface to userspace components. Strictly, the kernel
interface is expanded all the time, but old stuff keep working.

As you said - individual components may change. The kernel
is one such individual component, and it changes a lot.
The kernel offer *no* internal interfaces. A driver written
assuming a particular kernel-internal interface is broken
and unsupported *by design*. The vendor can still choose
to support such a driver, typically with a new version for
each kernel version. Nvidia seems to go that route with
their unsupported driver.  Your vendor instead selected to
leave you stranded. That is entirely the vendors fault,
that driver was never supported by the kernel community.
> I don't remember how it was during 2.4 and before, but I 
> find it very suspicious that SuSE and RedHat only provide 
> 2.6.10 and 2.6.9 for their OS. It looks as if THEY didn't 
> trust 2.6.x to be a replacement to 2.6.y
>
> And as I understand it, this is (was ?) the whole point of 
> stable/development kernels. "We" can trust a newer stable 
> kernel to be a drop-in replacement for an older stable 
> kernel (from the same series), while development kernels 
> need time to stabilise with the new whizz-bang-pfouit stuff 
> that you all so nicely add. 
>
> Are the good ol' days lost in nostalgia ?
>   
Upgrading 2.6.x kernels is supposed to work fine,
but you must upgrade the whole kernel then.  This includes
all driver modules. An older module may not work,
or it may even hang the kernel immediately. You can't
generally put together pieces of different kernels - the kernel
is one piece.  (Other pieces of a linux system is the
various packages your distribution vendor ships . . .)

Helge Hafting

