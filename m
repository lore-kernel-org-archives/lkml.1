Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZDMBVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZDMBVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 21:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZDMBV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 21:21:27 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:47346 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734AbZDMBV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 21:21:26 -0400
Message-ID: <49E29386.20204@solemnwarning.net>
Date: Mon, 13 Apr 2009 02:21:10 +0100
From: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 /proc/diskstats
References: <49E13D18.2090805@solemnwarning.net>
In-Reply-To: <49E13D18.2090805@solemnwarning.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=4J9GnK0NU8PFg4qgppoA:9 a=M2UmFvomYaTM5H23t7fau_b5Y1oA:4 a=CWfAmLVWKswA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've stepped through the commits in linux-2.6, the first revision with 
this behavior is 074a7aca7afa6f230104e8e65eba3420263714a5

Daniel Collins wrote:
> Hi
>
> Since 2.6.28, fd0 isn't visible in /proc/diskstats from boot, only 
> after access/mount. It is visible in /sys/block/ from boot, so there 
> are no issues detecting it. This may also affect other devices such as 
> hda but I haven't tested this yet, my test system and QEMU both only 
> have ram0-ram15 from boot. I have tested 2.6.30-rc1 and found the same 
> behavior. Is this a bug or a deliberate change?
>
> Thanks
