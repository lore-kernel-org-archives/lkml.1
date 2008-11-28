Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYK1CXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYK1CXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYK1CXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:23:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:35004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYK1CXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:23:43 -0500
Message-ID: <492F5613.4090908@kernel.org>
Date: Fri, 28 Nov 2008 11:23:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 02:23:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Thursday 2008-08-28 22:01, Adrian Bunk wrote:
>> On Thu, Aug 28, 2008 at 09:05:53PM +0200, Tejun Heo wrote:
>>> Hello again,
>>>
>>> So, after all the fuss, here's the state-of-the-art standard-compliant
>>> cloud-computing web-3.0-beta web page for OSS emulation using CUSE.
>>>
>>>   http://userweb.kernel.org/~tj/ossp/
>>>
>>> It works pretty well here.  :-)
>> Sorry for being destructive, but 6 years after ALSA went into the
>> kernel we are slightly approaching the point where all applications 
>> support ALSA.
> 
> Unreal Tournament GOTY/99 does not (seem to). And I doubt someone
> is going to fix commercial games. Though being a static binary,
> its use of shared libraries that do the sound device open makes
> aoss a possibility, if that helps. But it does not support ALSA
> natively - and would make a point for CUSE.

The devel version of ossp (not out yet, waiting for CUSE and mmap
support merge) can do all the quakes (even the dreaded quake1 which
even ALSA OSS emulation or native OSS can't do because of strict
sample/freq requirement which modern devices don't support anymore)
and skype-static-oss are working fine.  The latency is still a tad bit
high due to PA interaction but everything is mostly in place.  I'm
fairly sure UT would work too.  Do you know where I can get a demo of
it?

Thanks.

-- 
tejun
