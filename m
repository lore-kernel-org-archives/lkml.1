Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbXHFGjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbXHFGjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762832AbXHFGid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:38:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:42079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762765AbXHFGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:38:32 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19rkv4oMuRrCj8jzem5Yo+MMHYqBUUDZhLLi9b9BR
	suowqxcN8ruluf
Message-ID: <46B6C180.3020004@gmx.net>
Date: Mon, 06 Aug 2007 08:36:48 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>, Herbert Poetzl <herbert@13thfloor.at>,
       Andrey Savochkin <saw@sw.ru>, Adrian Bunk <bunk@stusta.de>,
       Cedric Le Goater <clg@fr.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Andrew Morgan <agm@google.com>
Subject: Re: CLONE_NEWUSER documentation
References: <46B599C6.7040201@gmx.net> <m1643ukviw.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1643ukviw.fsf@ebiederm.dsl.xmission.com>
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
>> In 2.6.23-rc, your patch to add support for CLONE_NEWUSER is included.  Is
>> there there some for-userland-programmers documentation of this flag
>> somewhere?  Would you be able to send some documentation to me (ideally as
>> a patch to the clone.2 man page, but otherwise some plain text will do).
>>
>> If this flag is also supported for unshare(), then could you please send me
>> a patch/text for that too?
> 
> Currently this namespace is a work in progress marked with CONFIG_EXPERIMENTAL
> because it is very much still experimental and under development.
> 
> There may be other omissions but the one I am most aware of is that
> the in kernel user and group equality comparisons have not become been
> transformed from the form uid1 == uid2 to user_namespace1 == user_namespace2 &&
> uid1 == uid2.
> 
> Until that happens that user namespace remains incomplete and not very
> useful.  So the advice to users for now that unless they want to help
> finish this up do not use.

And again: is CLONE_NEWUSER (to be)implemented for unshare()?

Thanks Eric.  I'm still not so clear though.  What is a user name space
intended to be, and how is it to be used?

Also, when will the implementation be complete?  If not by the 2.6.23 final
release, it seems unfortunate to expose this flag to userspace, since
further down the road, it will be difficult for userspace to tell whether
the kernel below it really supports the flag or not.  Or am I missing
something?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
