Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXGJRTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXGJRTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbXGJRS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:18:26 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:40317 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761308AbXGJRSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:18:25 -0400
Message-ID: <4693BF02.2050705@gentoo.org>
Date: Tue, 10 Jul 2007 13:16:50 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org> <4692BDEE.8020802@zytor.com>
In-Reply-To: <4692BDEE.8020802@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> User error.
> Please replace user and press any key.
> 
> # CONFIG_FIRMWARE_EDID is not set
> 
> The user has *explicitly* disabled acquisition of EDID from the
> firmware, so of course it doesn't probe for it.

I'm not versed with all this EDID and resolution stuff, but shouldn't 
the resolution be detected correctly under all configurations?

The original problem is that as of 2.6.20.11, the resolution is 
misdetected - it is wrong by 6 pixels. The same configuration with 
2.6.20.10 works fine.

With the 2.6.20.10/2.6.20.11 configuration, the user did have 
CONFIG_FIRMWARE_EDID set. I'm not sure why he changed this for the -mm 
testing, but then again I don't understand why it should matter.

Daniel
