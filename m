Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZF2UAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZF2UAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZF2UAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:00:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZF2UAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:00:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CPDbUHIhOK07EQHQVp+KAqpTqYavbNFao88E08vulafByN0Bpms5sk3E40eFzP+Od
	33fFRVkV1ucpNcZIMcYhw==
MIME-Version: 1.0
In-Reply-To: <20090629123840.1e20f17d.akpm@linux-foundation.org>
References: <20090629111029.GA15514@elf.ucw.cz>
	 <20090629123840.1e20f17d.akpm@linux-foundation.org>
Date: Mon, 29 Jun 2009 13:00:33 -0700
Message-ID: <a55d774e0906291300u3bb9b491r124f27fdf832b495@mail.gmail.com>
Subject: Re: Framebuffer support for HTC Dream
From: Brian Swetland <swetland@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       Dima Zavin <dima@android.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 12:38 PM, Andrew
Morton<akpm@linux-foundation.org> wrote:
> On Mon, 29 Jun 2009 13:10:30 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
>> I cleaned up dead code, a lot of debugging infastructure and horrific
>> logo code. I had to remove earlysuspend support, because neccessary
>> headers are not in mainline. The driver still works :-).
>
> So you didn't wrote the code?
>
>> This adds support for framebuffer on HTC Dream smartphone (aka
>> T-Mobile G1, aka ADP1).
>>
>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> Cc: Brian Swetland <swetland@google.com>
>
> Someone did.  Are the signoffs and attributions correct and
> appropriate?  Should we at least mention the driver's history in the
> changelog?
>
> Will it have a maintainer?

I did the original quick and dirty version for bringup.  Rebecca took
over and (re)wrote the bulk of the driver, getting things stable for
production ship of Dream and Sapphire, and Dima is currently adding
support for later Qualcomm chipsets (QSD8x50, etc).  Looping them into
this discussion.

It would probably be worth referring to drivers like this as "for
Qualcomm MSM/QSD SoCs" or the like, since they do work with a lot of
hardware beyond just Dream.

Brian
