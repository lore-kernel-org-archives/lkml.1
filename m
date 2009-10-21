Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZJUTnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZJUTnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZJUTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:43:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35190 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZJUTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:43:34 -0400
Date: Wed, 21 Oct 2009 12:44:40 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mtk.manpages@gmail.com, Matt Helsley <matthltc@us.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091021194440.GA1283@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com> <20091019235012.GF27627@count0.beaverton.ibm.com> <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com> <4ADF06B7.50508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF06B7.50508@zytor.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin [hpa@zytor.com] wrote:
> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
>>
>> My question here is: what does "3" actually mean? In general, system
>> calls have not followed any convention of numbering to indicate
>> successive versions -- clone2() being the one possible exception that
>> I know of.
>>
>
> "3" is number of arguments.

To me, it is a version number.

mmap() and mmap2() both have 6 parameters.

Besides if wait4() were born before wait3(), would it still be wait4() :-)
But I see that it is hard to get one-convention-that-fits-all.

> It's better than "extended" or something  
> like that simply because "extended" just means "more than", and a number  
> at least tells you *how much more than*.

And extended assumes we wont extend again.

An informal poll of reviewers has clone3() with a slight advantage :-)

	clone_extended() camp: Serge Hallyn, Kerrisk, Louis Rilling, 
	clone3(): Sukadev, H. Peter Anvin, Oren, Matt Helsley.

I like clone3() but am not insisting on it. I just want a name...

Sukadev
