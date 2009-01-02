Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbZABKqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbZABKqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:46:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbZABKly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:54 -0500
Received: from main.gmane.org ([80.91.229.2]:58589 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZABKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:43 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 02 Jan 2009 10:41:22 +0000
Message-ID: <yw1x3ag2t2gd.fsf@thrashbarg.mansr.com>
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:KkdFZ1gOGHtad6wzPau8uuF3Hg0=
Cc: linux-embedded@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Mery <amery@opensde.org> writes:

> Christoph Hellwig escribió:
>> On Fri, Jan 02, 2009 at 10:26:37AM +0100, Arkadiusz Miskiewicz wrote:
>>   
>>> On Friday 02 of January 2009, Rob Landley wrote:
>>>     
>>>> Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0dc2 )
>>>> building a Linux kernel never required perl to be installed on the build
>>>> system.  (Various development and debugging scripts were written in perl
>>>> and python and such, but they weren't involved in actually building a
>>>> kernel.) Building a kernel before 2.6.25 could be done with a minimal
>>>> system built from gcc, binutils, bash, make, busybox, uClibc, and the Linux
>>>> kernel, and nothing else.
>>>>       
>>> And now bash is going to be required... while some distros don't need/have 
>>> bash. /bin/sh should be enough.
>>>     
>>
>> *nod*  bash is in many ways a worse requirement than perl.  strict posix
>> /bin/sh + awk + sed would be nicest, but if that's too much work perl
>> seems reasonable.
> well, bash is not worse as bash is trivial to cross-compile to run on a
> constrained sandbox and perl is a nightmare, but I agree bash should be
> avoided too.
>
> I think the $(( ... )) bash-ism can be replaced with a simple .c helper toy.

The $(( ... )) construct is standard POSIX shell syntax, see
http://www.opengroup.org/onlinepubs/000095399/utilities/xcu_chap02.html#tag_02_06_04

Bash supports $[ ... ] as an alternate syntax for the same thing.
Perhaps you were thinking of that.

-- 
Måns Rullgård
mans@mansr.com

