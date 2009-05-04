Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZEDGcK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 May 2009 02:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZEDGby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:31:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:42701 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752149AbZEDGby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:31:54 -0400
X-Authenticated: #8143315
X-Provags-ID: V01U2FsdGVkX1+pwnV04uqprsjKzerTLJqbj/VFbF+wbvY6c03OwK
	7+Ten2TNVg+ASH
Content-Type: text/plain; charset=utf-8
To: "Shaohua Li" <shaohua.li@intel.com>
Cc: "Jerome Glisse" <glisse@freedesktop.org>,
   "Andrew Morton" <akpm@linux-foundation.org>,
   "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
   "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
   "Dave Airlie" <airlied@linux.ie>, "stable@kernel.org" <stable@kernel.org>
Subject: Re: PROBLEM: 2.6.29.2 - AGP doesn't work anymore on my nforce2
References: <op.us6ywl2jgp7xae@127.0.0.1>
 <20090430175927.a89f1cd3.akpm@linux-foundation.org>
 <1241179733.2606.1.camel@localhost.localdomain>
 <55bc079c-5c3d-465a-be28-0e38c0b48b14@rrsmsx603.amr.corp.intel.com>
 <20090504014151.GA22872@sli10-desk.sh.intel.com>
Date: Mon, 04 May 2009 08:31:44 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
FROM: Karsten Mehrhoff <kawime@gmx.de>
Message-ID: <op.utd626zcgp7xae@127.0.0.1>
In-Reply-To: <20090504014151.GA22872@sli10-desk.sh.intel.com>
User-Agent: Opera Mail/10.00 (Linux)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 May 2009 03:41:51 +0200, Shaohua Li wrote:
> On Fri, May 01, 2009 at 09:22:19PM +0800, kawime@gmx.de wrote:
>>> On Thu, 2009-04-30 at 17:59 -0700, Andrew Morton wrote:
>>>> On Thu, 30 Apr 2009 10:51:47 +0200
>>>> Karsten Mehrhoff <kawime@gmx.de> wrote:
>>>>
>>>>> [1.]
>>>>> PROBLEM: No more agp card functionality with the patch 2.6.29.2 of
>>>> 'a/drivers/char/agp/generic.c'
>>>>>
>>>>> [2.]
>>>>> I compiled the kernel 2.6.29.2 with my .config of 2.6.29.1 and run
>>>> into problems with the speed of my ATI RADEON 9600 (rv350)
>>>>>
>>>>
>>>
>>> Is your problem speed issue ? ie just a slowdown ? Or does AGP stop
>>> working with this patch ? Slowdown is expected from this patch but
>>> it should hurt too much.
>>>
>>
>>                        2.6.29.1  | 2.6.29.2
>>                         --------  |  --------
>> glxgears             ~ 2900 FPS  |  ~ 75 FPS
>> glxgears -fullscreen ~  500 FPS  |  ~ 11 FPS
> Does this patch alone give so huge slowdown? From my little knowledge,  
> xserver
> does agp pages allocation only at startup.

I only reverted this patch in the source file (/drivers/char/agp/generic.c) and got back my old speed on 2.6.29.2.
