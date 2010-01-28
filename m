Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118Ab0A1Jpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0A1Jpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914Ab0A1Jpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:45:43 -0500
Received: from mail.yrkesakademin.fi ([85.134.44.20]:39020 "EHLO
	mail.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0A1Jpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:45:41 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 04:45:41 EST
Message-ID: <4B615ABE.7000702@mandriva.org>
Date: Thu, 28 Jan 2010 11:37:02 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, ataraid-list@redhat.com,
       linux-raid@vger.kernel.org
Subject: Re: kernel BUG at fs/dcache.c:670 using dmraid
References: <4B60C5C5.3040604@mandriva.org>
In-Reply-To: <4B60C5C5.3040604@mandriva.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund skrev 28.1.2010 01:01:
> Hi, (please cc me on response)
>

[fixed typo in subject and message]

>
> I'm hitting a kernel BUG at fs/dcache.c:670 bug using dmraid on 2.6.32
> and 2.6.33-rc5-git2 kernels:
>
> Distro: Mandriva Linux Cooker
> Arch: x86_64
>
> Hardware: Intel ICH10R with 4 x 500GB disks in biosraid10,
> System has 8GB ram
>
> OOPS: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/dsc00918.jpg
> config: http://tmb.mine.nu/Mandriva/Cooker/bugs/fs-dcache-bug/x86_64.config
>
> This happends on 2.6.33-rc5-git2, 2.6.32, and seems to be as old as
> 2.6.32-rc1.
>
> 2.6.31 is the latest kernel that actually boots on this system.
>
> I tried to bisect between 2.6.31 and 2.6.32-rc1, but it failed...
>
> Now before I start a second bisect, I decided to post here in case some
> one has some suggestions / pointers...
>

--
Thomas
