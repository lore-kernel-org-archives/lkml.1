Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXHFGie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXHFGie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbXHFGiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:38:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:51726 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762255AbXHFGiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:38:20 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18JiNU3AU8JhDdABmv53sOhwltp4ARXenoI7+4He5
	VKU7ejjbs+LaCd
Message-ID: <46B6C177.8040405@gmx.net>
Date: Mon, 06 Aug 2007 08:36:39 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: CLONE_NEWUTS documentation
References: <46B599CA.9030302@gmx.net> <m1abt6kvym.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abt6kvym.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote:
> Michael Kerrisk <mtk-manpages@gmx.net> writes:
> 
>> Hello Serge,
>>
>> In 2.6.19, your patch to add support for CLONE_NEWUTS was included.  Is
>> there there some for-userland-programmers documentation of this flag
>> somewhere?  Would you be able to send some documentation to me (ideally as
>> a patch to the clone.2 man page, but otherwise some plain text will do).
>>
>> If this flag is also supported for unshare(), then could you please send me
>> a patch/text for that too?
> 
> Again a short summary
> 
> The utsname namespace encapsulates the global kernel identification stored
> in struct utsname returned from uname(2).
> 
> It is a very trivial namespace but it allows you to set multiple hostnames
> and nis domainnames on the same machine.

Thanks Eric.

And a further question: is CLONE_NEWUTS implemented for unshare()?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
