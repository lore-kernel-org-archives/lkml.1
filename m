Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYK1Lfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYK1Lfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYK1Lff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:35:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52831 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYK1Lfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:35:34 -0500
Date: Fri, 28 Nov 2008 12:35:32 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tejun Heo <tj@kernel.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
In-Reply-To: <492F5613.4090908@kernel.org>
Message-ID: <alpine.LNX.1.10.0811281220510.3843@fbirervta.pbzchgretzou.qr>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr> <492F5613.4090908@kernel.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-11-28 03:23, Tejun Heo wrote:
>Jan Engelhardt wrote:
>> On Thursday 2008-08-28 22:01, Adrian Bunk wrote:
>>> On Thu, Aug 28, 2008 at 09:05:53PM +0200, Tejun Heo wrote:
>>>> Hello again,
>>>>
>>>> So, after all the fuss, here's the state-of-the-art standard-compliant
>>>> cloud-computing web-3.0-beta web page for OSS emulation using CUSE.
>>>>
>>>>   http://userweb.kernel.org/~tj/ossp/
>>>>
>>>> It works pretty well here.  :-)
>>> Sorry for being destructive, but 6 years after ALSA went into the
>>> kernel we are slightly approaching the point where all applications 
>>> support ALSA.
>> 
>> Unreal Tournament GOTY/99 does not (seem to). And I doubt someone
>> is going to fix commercial games. Though being a static binary,
>> its use of shared libraries that do the sound device open makes
>> aoss a possibility, if that helps. But it does not support ALSA
>> natively - and would make a point for CUSE.
>
>The devel version of ossp (not out yet, waiting for CUSE and mmap
>support merge) can do all the quakes (even the dreaded quake1 which
>even ALSA OSS emulation or native OSS can't do because of strict
>sample/freq requirement which modern devices don't support anymore)

Quake won't be a problem because its source was released.

>and skype-static-oss are working fine.

Skype should burn in hell...

>The latency is still a tad bit
>high due to PA interaction but everything is mostly in place.  I'm
>fairly sure UT would work too.  Do you know where I can get a demo of
>it?

It has become really difficult to obtain these nowadays, but there it is:

http://download.beyondunreal.com/get.php/2/official/ut/utdemo-linux-x86-348.tar.gz


(BTW, Firefox3 screws up on loading
http://download.beyondunreal.com/fileworks.php/official/ut/utdemo-linux-x86-348.tar.gz
w3m works fine and was used to obtain the nested link above.)
