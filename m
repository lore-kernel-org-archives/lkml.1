Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXA0XF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXA0XF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXA0XF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 18:05:26 -0500
Received: from mail.portrix.net ([212.202.157.208]:59415 "EHLO
	zoidberg.portrix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbXA0XFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 18:05:25 -0500
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jan 2007 18:05:24 EST
Message-ID: <45BBD6A5.8080502@ppp0.net>
Date: Sat, 27 Jan 2007 23:48:05 +0100
From: Jan Dittmer <jdittmer@ppp0.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Thunderbird/1.5.0.9 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Willy Tarreau <w@1wt.eu>, Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Ingo@maccavity.nachtwache.org, Christoph@maccavity.nachtwache.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Martin J. Bligh" <mbligh@mbligh.org>, Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Molnar <mingo@redhat.com>,
       ltt-dev@shafik.org, systemtap@sources.redhat.com,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@eecs.ku.edu>
Subject: Re: [Ltt-dev] [PATCH 00/09] atomic.h : standardizing atomic primitives
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca>	<20070127021834.e26e955d.akpm@osdl.org>	<20070127181116.GA5158@Krystal>	<20070127120512.04a98fcd.akpm@osdl.org>	<20070127200910.GC24090@1wt.eu> <20070127123004.ea422fe4.akpm@osdl.org>
In-Reply-To: <20070127123004.ea422fe4.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 27 Jan 2007 21:09:11 +0100
> Willy Tarreau <w@1wt.eu> wrote:
> 
>> On Sat, Jan 27, 2007 at 12:05:12PM -0800, Andrew Morton wrote:
>>> On Sat, 27 Jan 2007 13:11:16 -0500
>>> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
>>>
>>>> I am currently trying crosstool by Dan Kegel, it looks promising.
>>>> http://www.kegel.com/crosstool/
>>> Yeah, I spent a frustrating two days with crosstool, managed to eke a
>>> number of cross-compilers out of it, but it took a *lot* of experimentation
>>> with gcc, glibc and binutils versions to get combinations which actually
>>> work.  Good luck ;)
>>>
>>> There used to be someone who had a full suite, and who regularly published
>>> cross-compile results, but he stopped 6-12 months ago and I forget who that
>>> clever person was?
>> Wasn't it buildroot from Erik Andersen ?
>>
>>    http://buildroot.uclibc.org/
>>
> 
> No, it was http://l4x.org/k/ It still appears to be operating, with
> scary-looking results.
> 
> Jan, is there any way in which you can help us publish a full suite of
> cross-compiler binaries?

Probably not. I could publish a qemu i386 image with all cross compilers
though. But some are not build from source but are obtained from more or
less obscure sources (m32r, sh64). Currently this

 CHK     include/linux/utsrelease.h
"2.6.20-rc6cat:include/config/kernel.release:Nosuchfileordirectory" exceeds 64 characters
make[1]: *** [include/linux/utsrelease.h] Error 1
make: *** [_all] Error 2

bug, which I reported weeks ago, makes the result invalid for most
archs. But as I get nearly zero feedback about the results and I've
lots of other obligations currently, my motivation to work on that is
pretty much nil.

Jan
