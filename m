Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXFZTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXFZTaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXFZT3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:29:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50488 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323AbXFZT3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:29:38 -0400
Message-ID: <468168ED.2040706@goop.org>
Date: Tue, 26 Jun 2007 15:28:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org> <Pine.LNX.4.64.0706251714410.4386@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0706251714410.4386@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
>> 	linux/elf-const.h	- ELF constants, includable by asm code
>>     
>
> BTW who's the maniac who tries to use this in asm code?
> Many of these constants are pretty useless without the corresponding 
> structure definitions.

I was for a while, in order to hand-craft ELF headers for the bzImage 
boot image, but I since changed it to define these structures from C.  
Still, its useful to have the constants separate, since they are used 
separate from their corresponding structures.

    J
