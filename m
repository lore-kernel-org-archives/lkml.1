Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZIVRNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZIVRNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZIVRNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:13:41 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:44659 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbZIVRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:13:40 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 2952A3328DB
Message-ID: <4AB905C6.2040605@arcor.de>
Date: Tue, 22 Sep 2009 20:13:42 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Brian McGrew <brian@visionpro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: (un)mount ramfs from C code
References: <C6DE438F.127DA%brian@visionpro.com>
In-Reply-To: <C6DE438F.127DA%brian@visionpro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 07:04 PM, Brian McGrew wrote:
> Good morning all!
>
> So I'm using a ramfs for temporary files, thank you whoever designed that,
> it works great!
>
> I can mkdir, mount, chmoud, readand write and then umount the thing from the
> command line just fine.
>
> What I need now is some method from within my C/C++ code to determine if the
> ramfs is mounted, if not, then mount it so I can use it and unmount it when
> I'm done, without making a system call.
>
> Can this be done?  Is there any access to mount/unmount from C/C++?

I suppose looking at the source code of the 'mount' utility could prove 
very enlightening.  You can find it at:

   http://www.kernel.org/pub/linux/utils/util-linux-ng
