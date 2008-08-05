Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYHEOgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYHEOgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYHEOf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:35:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48411 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754221AbYHEOfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:35:55 -0400
Message-ID: <4898654A.9000904@sgi.com>
Date: Tue, 05 Aug 2008 07:35:54 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
 on SGI UV
References: <20080731195753.GB25715@sgi.com> <48934926.2010200@zytor.com>	 <20080804221951.GA252105@sgi.com> <f73f7ab80808042221v5bebcea9o7e536093373647cd@mail.gmail.com>
In-Reply-To: <f73f7ab80808042221v5bebcea9o7e536093373647cd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Mon, Aug 4, 2008 at 6:19 PM, Russ Anderson <rja@sgi.com> wrote:
>> On Fri, Aug 01, 2008 at 10:34:30AM -0700, H. Peter Anvin wrote:
>>> Russ Anderson wrote:
>>>> +# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)          \
>>>> +    do {                                                            \
>>>> +            /* XXX - the real call goes here */                     \
>>>> +            result.status = BIOS_STATUS_UNIMPLEMENTED;              \
>>>> +            result.v0 = 0;                                          \
>>>> +            result.v1 = 0;                                          \
>>>> +    } while (0)
>>> I have more than a little problem with submitting patches like this.  We
>>> have no way to judge the suitability of the coding or the interface with
>>> the "meat" of the driver stubbed out!
>> This is also code for hardware that does not exist.  In order for the
>> code to be in distro releases in time for the hardware to ship, we
>> must push it _before_ we have hardware.  The main concern is getting in
>> interfaces now, because the interfaces cannot change in a minor release.
>> Providing more "meat" is on the ToDo list.
> 
> These kinds of statements are not the way to get things done on LKML.
> Quite a number of people have gotten flamed/ignored/etc lately by
> making statements "We need this (unfinished code) in the kernel by
> 2.6.27 because RHEL6 is going to use 2.6.27 and otherwise we won't be
> supported in RHEL6".
> 
> Cheers,
> Kyle Moffett

Hi Kyle,

As I'm very new to this development arena, could you explain a bit more
on why this is considered "bad manners"?

I'm not speaking of any particular change, but there are some realities in
bringing a new product to market that depends heavily on new "features"
being accepted into a specific kernel release.  I certainly do not want
to "taint" any kernel code (and I'm always amazed at the dedication of
so many individuals to insure this doesn't happen), but the line between
acceptability (and not) seems to waver all over the place... ;-)

Thanks,
Mike

