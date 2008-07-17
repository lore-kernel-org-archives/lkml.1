Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbYGQXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbYGQXBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYGQXBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:01:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:52386 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYGQXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:01:34 -0400
Date: Thu, 17 Jul 2008 16:02:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: el es <el_es_cr@yahoo.co.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
In-Reply-To: <loom.20080717T083755-676@post.gmane.org>
Message-ID: <alpine.DEB.1.10.0807171558450.17859@asgard.lang.hm>
References: <loom.20080717T083755-676@post.gmane.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, el es wrote:

> Hello,
> inspired by the bikeshed painting contest, I got the following idea :
>
> The scheme to be s.yy.ww.tt, that is :
>
> s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
> for example ;) )
>
> yy - two (in a hundred years, three) digits of the year
>
> Now the interesting part begins which is
>
> ww - the number of the week of the release. This will be between 1 and 52 (53)
>
> tt - the number of the week of stable release. As above.
>
> I see it like :
>
> Take a hypotetical new-scheme 2.8.30 release (roughly the current 2.6.26, didn't
> count these weeks). Linus starts to accumulate patches for 2.8.30-rcX as usual,
> and when he is ready to release, puts the release week number instead of 30 -
> let's assume it is a 2.8.40 then, more or less. By the time, the stable team
> produces 2.8.30.[32,34,36,38,40 and so on]. If the weeks leap into the next
> year, stable team puts e.g. 2.8.30.9.01 (yy.ww). This scheme would reflect the
> fast pace of development quite good, and also have the information, when the
> code in question was produced actually. I think the weekly granularity is quite
> good idea anyway.
>
> What do you think ?

it means that you cannot know what version of the kernel you are getting 
ready to release.

today we can talk that we are working on 2.6.27 or 'this feature was 
accepted and will be in 2.6.27' any scheme that uses the date of the 
release means that we can't do this.

I see this as a big problem with a fine-grained date scheme.

if we use the year in a date-based scheme and have a near end-of-year 
release slip into the next year (2008.4 is released in Jan 2009) I don't 
see this as a major problem (the bulk of the work was done in 2008 even if 
the final release hit in 2009) under the current development cycle it's 
not like this will end up with 'version 2009.2 released in 2011' type 
emberrasements.

David Lang
