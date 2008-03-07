Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbYCGM3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbYCGM3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYCGM3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:29:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYCGM3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:29:16 -0500
Message-ID: <47D134EC.6050804@zytor.com>
Date: Fri, 07 Mar 2008 04:28:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
References: <200803060001.38432.paplociennik@gmail.com>	 <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu>	 <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>	 <47D06265.8030305@zytor.com> <1204886161.15966.17.camel@tara.firmix.at>
In-Reply-To: <1204886161.15966.17.camel@tara.firmix.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> On Don, 2008-03-06 at 13:30 -0800, H. Peter Anvin wrote:
>> Pavel Machek wrote:
>>> This really should be in kernel, I should not have to partition my
>>> disk to get booting to few different distros.
>>>
>> Use a small initramfs.  That's the Right Thing to do in the first place.
> 
> ... or use a statically linked chroot program (not necessarily to be
> found in /working_distro). Shouldn't be too large anyways ....
> 

For what it's worth:

: tazenda 102 ; ls -l ~/klibc/klibc/usr/utils/static/chroot
-rwxrwxr-x 1 hpa hpa 8488 2008-03-06 14:04 
/home/hpa/klibc/klibc/usr/utils/static/chroot*

	(compiled for x86-64)

	-hpa
