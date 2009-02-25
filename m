Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbZBYHU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbZBYHU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZBYHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:20:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZBYHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:20:15 -0500
Message-ID: <49A4F051.3000706@zytor.com>
Date: Tue, 24 Feb 2009 23:16:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [rfc] headers_check cleanups break the whole world
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu> <20090225070511.GG6690@bombadil.infradead.org> <49A4EE85.5000907@zytor.com> <20090225071347.GH6690@bombadil.infradead.org>
In-Reply-To: <20090225071347.GH6690@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Tue, Feb 24, 2009 at 11:08:53PM -0800, H. Peter Anvin wrote:
>> Because <linux/types.h> should work just fine once we get rid of the
>> __KERNEL_STRICT_NAMES idiocy?
>>
>> FWIW, Arnd Bergmann has been working on exactly this cleanup.
>>
> 
> Ah good, I was about to cook a patch, then I realized there's probably
> quite a mess of userspace things depending on, say, sector_t and such.
> 
> This is a pretty ugly problem, all things considered. :/
> 

Not all that bad, actually.

This is the last patch I've seen on the subject:

http://marc.info/?i=200902051707.55457.arnd@arndb.de

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

