Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbXGIXIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbXGIXIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 19:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbXGIXIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 19:08:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172AbXGIXIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 19:08:04 -0400
Message-ID: <4692BDEE.8020802@zytor.com>
Date: Mon, 09 Jul 2007 15:59:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       zwane@infradead.org, Andi Kleen <ak@suse.de>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com>	<4686D85B.6090803@gentoo.org>	<20070630154230.4ad373fa.akpm@linux-foundation.org>	<4690E65B.5050607@gentoo.org> <20070708111404.1486e73c.akpm@linux-foundation.org> <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>
In-Reply-To: <4692BC61.9070500@gentoo.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> H. Peter Anvin wrote:
>> The patch should be fine for 2.6.22, but for -mm, the code this patches
>> doesn't even exist with git-newsetup; nor is there a CONFIG_VIDEO_SELECT
>> which could impede the production of the VESA version.
>>
>> What does your .config look like?
> 
> https://bugs.gentoo.org/attachment.cgi?id=124339&action=view
> 

User error.
Please replace user and press any key.

# CONFIG_FIRMWARE_EDID is not set

The user has *explicitly* disabled acquisition of EDID from the
firmware, so of course it doesn't probe for it.

	-hpa
