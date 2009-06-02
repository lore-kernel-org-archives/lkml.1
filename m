Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZFBDKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZFBDKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZFBDKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:10:01 -0400
Received: from www.crouse-house.com ([199.45.160.146]:44307 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbZFBDKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:10:00 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2009 23:10:00 EDT
Message-ID: <4A24965C.2020901@cosmicpenguin.net>
Date: Mon, 01 Jun 2009 21:02:52 -0600
From: Jordan Crouse <jordan@cosmicpenguin.net>
Reply-To: jordan@cosmicpenguin.net
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Tobias_Mueller@twam.info,
       david-b@pacbell.net, gardner.ben@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>	<20090526151621.a7446c60.akpm@linux-foundation.org>	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>	<20090601165457.a1cc1025.akpm@linux-foundation.org> <20090601200821.62b04e43@mycelium.queued.net>
In-Reply-To: <20090601200821.62b04e43@mycelium.queued.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:
> On Mon, 1 Jun 2009 16:54:57 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> [...]
>> Back in February, Andres sent out a patch "cs553x-gpio: add AMD
>> CS5535/CS5536 GPIO driver support".  AFACIT that patch does the same
>> thing that this one does, but differently.  IIRC it had a great string
>> of weird-Kconfig-related build errors and I eventually dropped it.
>>
>> What's the story here?
>>
>> Thanks.
> 
> My story is that I've since switched employers twice since Feb, and will
> be resubmitting the patch now that sanity has returned to my life.
> I'm planning to get to it within the next week.
> 
> As far as Tobias's driver, one major difference between our drivers is
> that mine doesn't grab the entire PCI device.  This is because other
> drivers (ie, the MFGPT driver) will want to share the PCI device.

Also SMBUS. In fact, they *must* share the PCI device if they all want 
to play well together, so that alone would probably push us toward 
Andre's patch, once it gets clean.

Jordan
