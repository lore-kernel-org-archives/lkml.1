Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbZJSXuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbZJSXuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbZJSXuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:50:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42980 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbZJSXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:50:11 -0400
Date: Mon, 19 Oct 2009 16:50:12 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       mtk.manpages@gmail.com, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091019235012.GF27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADCDAA8.5080408@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 06:31:20AM +0900, H. Peter Anvin wrote:
> On 10/20/2009 02:44 AM, Matt Helsley wrote:
>>> |
>>> | I know I'm late to this discussion, but why the name clone3()? It's
>>> | not consistent with any other convention used fo syscall naming,
>
> This assumption, of course, is just plain wrong.  Look at the wait  
> system calls, for example.  However, when a small integer is used like  
> that, it pretty much always reflects numbers of arguments.
>
>>> | AFAICS. I think a name like clone_ext() or clonex() (for extended)
>>> | might make more sense.
>>>
>>> Sure, we talked about calling it clone_extended() and I can go back
>>> to that.
>>>
>>> Only minor concern with that name was if this new call ever needs to
>>> be extended, what would we call it :-). With clone3() we could add a
>>> real/fake parameter and call it clone4() :-p
>>
>> Perhaps clone64 (somewhat like stat64 for example)?
>>
>
> I think that doesn't exactly reflect the nature of the changes.

Yes. Without adopting an impractical encoding scheme it's quite
unlikely a small number like 3 or 64 could exactly reflect all the
changes :). I don't think that's a realistic objection though so...

> clone3() is actually pretty good.

I agree.

Cheers,
	-Matt Helsley
