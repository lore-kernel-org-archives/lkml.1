Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZJZRSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZJZRSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZJZRSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:18:34 -0400
Received: from mail.lang.hm ([64.81.33.126]:56589 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZJZRS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:18:26 -0400
Date: Mon, 26 Oct 2009 10:18:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "John W. Linville" <linville@tuxdriver.com>
cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
In-Reply-To: <20091026165518.GE2792@tuxdriver.com>
Message-ID: <alpine.DEB.2.00.0910261013430.11504@asgard.lang.hm>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009, John W. Linville wrote:

> On Fri, Oct 23, 2009 at 06:10:06PM +0200, Pavel Machek wrote:
>> On Tue 2009-10-20 14:17:07, John W. Linville wrote:
>>> Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
>>> several years this driver has only seen API "bombing-run" changes, and
>>> few people ever had the hardware.  This driver represents unnecessary
>>> ongoing maintenance for no clear benefit.
>>
>> This seems like abuse of the staging process.
>
> My mailbox has been filling-up with discussions of using staging like
> this for the past few weeks.  I'm reasonably certain those threads
> were on the public lists.
>
>> There's no TODO to say what needs to be fixed. You just don't want to
>> maintain it. Because there's nothing to fix, noone has reason to patch
>> it, and the (working, good enough) driver will just be removed.
>
> "ongoing maintenance for no clear benefit" -- that is what is wrong
> with it.

supporting existing hardware is no longer a 'clear benifit'?

is this driver broken (as in not working)?

other than the fact that you don't think many people have this hardware, 
is there anything wrong with this driver?

>> It also marks driver as broken when it is not...
>
> I didn't mark it broken, I proposed moving it to staging.  As for
> whether or not it actually is broken, how do you know?
>
> The drivers in this thread are for pre-802.11 devices -- old ones
> (e.g. ISA) at that.  If we actually have users that are willing
> to maintain them then maybe that is fine.  But I don't see the
> benefit of maintaining these simply as extra targets for API change
> "bombing runs"...
>
>> What about removing it in the regular way, that's
>> Documentation/feature-removal.txt ?
>
> This has been discussed recently as an alternative for unmaintained
> drivers.  I suspect this is better than adding a note to a file that
> no one reads...

this is exactly the type of thing I was afraid would start happening when 
I noticed the discussion. when I tried to bring it up I was told that this 
would only be used for things that were really broken or otherwise causing 
significant problems.

if this driver hasn't been changed other than for blanket API changes, how 
is it causing significant problems?

if someone were to claim 'maintainership' and then do nothing other than 
complain if someone else were to change an API but not fix this in the 
process, how would this be different than the current situation?

David Lang
