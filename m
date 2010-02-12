Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0BLWLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:11:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36702 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab0BLWLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:11:47 -0500
Message-ID: <4B75D1F9.5070501@zytor.com>
Date: Fri, 12 Feb 2010 14:11:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Sleddens, J.P.G." <j.p.g.sleddens@hro.nl>
CC: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, mirrors@kernel.org,
       users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org mirrors] [kernel.org users] XZ Migration	discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare> <4B75A5FE.8020408@zytor.com> <4B75C8CB.DBDA.0014.0@hro.nl>
In-Reply-To: <4B75C8CB.DBDA.0014.0@hro.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 12:31 PM, Sleddens, J.P.G. wrote:
>>>> On 12-2-2010 at 20:03, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> On 02/12/2010 06:01 AM, Jean Delvare wrote:
>>> 3* Create a new subdirectory for every 2.6.x kernel, and move all the
>>> related files there. This would shrink the main index drastically, and
>>> each subdirectory would have a reasonable size (except maybe 2.6.16 and
>>> 2.6.27.) Oddly enough this has been done for the files under testing/
>>> already, so I am curious why we don't do it for the release files (and
>>> the testing/incr/ files, while we're at it.)
>>
>> Well, part of the reason why is that we're functionally "stuck" on 2.6;
>> a prefix which really has lost all meaning.
>>
>> It might open up the question if we shouldn't just do a Solaris and drop
>> the leading 2 (so the next kernel would be 6.33) or call the kernel
>> after that 3.0 instead of 2.6.34, and then 3.1 instead of 2.6.35.
> 
> I remember the whole LKML discussion about this a few years back:
> http://lkml.org/lkml/2008/10/15/377 
> 
> The whole year.version   or year/month versioning Greg HK proposed
> made a lot of sense to me.  It would also solve our problem with the 2.6
> directory just growing and growing as the year versioning would make a
> natural hierarchy which keeps going no matter what.

Note also that every time this conversation happens it starts to pull
away in different directions, and as a result nothing happens.

I'm going to stick my foot in it and state the following: I think
incremental numbers work well, and everyone are used to them.  It
doesn't seem to be the major issue with the current scheme; the issue
with the current scheme is that we have one or two levels too much.

	-hpa
