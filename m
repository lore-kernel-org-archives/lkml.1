Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZJSVju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZJSVju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbZJSVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:39:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbZJSVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:39:48 -0400
Message-ID: <4ADCDAA8.5080408@zytor.com>
Date: Tue, 20 Oct 2009 06:31:20 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com>
In-Reply-To: <20091019174405.GE27627@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2009 02:44 AM, Matt Helsley wrote:
>> |
>> | I know I'm late to this discussion, but why the name clone3()? It's
>> | not consistent with any other convention used fo syscall naming,

This assumption, of course, is just plain wrong.  Look at the wait 
system calls, for example.  However, when a small integer is used like 
that, it pretty much always reflects numbers of arguments.

>> | AFAICS. I think a name like clone_ext() or clonex() (for extended)
>> | might make more sense.
>>
>> Sure, we talked about calling it clone_extended() and I can go back
>> to that.
>>
>> Only minor concern with that name was if this new call ever needs to
>> be extended, what would we call it :-). With clone3() we could add a
>> real/fake parameter and call it clone4() :-p
>
> Perhaps clone64 (somewhat like stat64 for example)?
>

I think that doesn't exactly reflect the nature of the changes.

clone3() is actually pretty good.

	-hpa
