Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZAQWet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZAQWet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759806AbZAQWea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:34:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZAQWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:34:28 -0500
Message-ID: <49725B1E.604@kernel.org>
Date: Sat, 17 Jan 2009 14:26:38 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       linux-media@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-raid@vger.kernel.org,
       dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
References: <1232223441.3966.22.camel@localhost.localdomain> <1232228261.27094.0.camel@macbook.infradead.org> <20090117221932.GA4956@uranus.ravnborg.org>
In-Reply-To: <20090117221932.GA4956@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>>  
>> That patch looks wrong, and unnecessary. It was fine before.
> Nope - include/linux/dvb/audio.h failed to include linux/types.h
> despite the fact that is uses __u32 etc.
> 
> But why the _kernel_ should include a userspace header is
> much more questionable.
> 

<stdint.h> is one of a handful of headers provided by gcc itself.

	-hpa
