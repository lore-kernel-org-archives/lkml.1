Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0CHXSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:18:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:3639 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0CHXSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <m1fx4apgch.fsf@fess.ebiederm.org>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <20100308190857.400bde09@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
	 <m1fx4apgch.fsf@fess.ebiederm.org>
Date: Mon, 8 Mar 2010 18:18:21 -0500
Message-ID: <7e0fb38c1003081518o7cddd121wa9c363a4e8211115@mail.gmail.com>
Subject: Re: Upstream first policy
From: Eric Paris <eparis@parisplace.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 6:02 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> On Mon, 8 Mar 2010, Alan Cox wrote:
>>>
>>> Quite untrue. I've actually *used* path based security systems (DEC10
>>> ACLs) and for almost every case its brain-dead.
>>>
>>> Imagine a world where this happened
>>
>> Alan, stop right there.
>>
>> You're making the same silly and incorrect mistake that Al did.
>>
>> Namely thinking that you have to have just one or the other.
>>
>> When you say "your /etc/passwd example is a special case", you are
>> admitting that there are two different cases, but then after that,  you
>> still don't see the whole point I'm trying to make.
>>
>> Let me try again:
>>
>>   THERE ARE DIFFERENT CASES
>>
>> That's the point. Just admit that, and then let the calm of "Ooh, there
>> are different kinds of circumstances that may want different kinds of
>> rules" permeate you.
>>
>> My whole (and only) argument is against the "only one way is correct"
>> mentality.
>
>
> Reading through all of this it occurred to me there is a case where
> path names are fundamentally important shows up for me all of the
> time.  If pathnames were not fundamentally important we could apply
> a patch like the one below and allow unprivileged users to unshare
> the mount namespace and mount filesystems wherever.  There is nothing
> fundamental about those operations that require root privileges except
> that you are manipulating the pathnames of objects.
>
> Unfortunately if we did that suid executables would become impossible
> because they couldn't trust anything to start with.

You do realize that with content based security systems the pathnames
aren't important and you could implement your example patch?  Sure a
user could mount something on /lib and put their own files there, but
since that user couldn't get them labelled correctly the suid app
would not be able to use them and would fail.  Users would have new
and interesting way to break their computers!  I thank you for your
vote for content based security systems instead of pathname systems
and look forward to your future contributions to either that body of
knowledge or the bridging of the gap between the two *smile*

-Eric
