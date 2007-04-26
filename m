Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXDZXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXDZXaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXDZXaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:30:52 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:55342 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755231AbXDZXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:30:51 -0400
Date: Thu, 26 Apr 2007 15:56:07 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070426232724.GL21695@elf.ucw.cz>
Message-ID: <Pine.LNX.4.63.0704261555110.9674@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <20070426224256.GB21926@elf.ucw.cz>  <Pine.LNX.4.63.0704261520350.9674@qynat.qvtvafvgr.pbz>
  <20070426231228.GI21695@elf.ucw.cz>  <Pine.LNX.4.63.0704261545100.9674@qynat.qvtvafvgr.pbz>
 <20070426232724.GL21695@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Pavel Machek wrote:

> Hi!
>
>>> That's a feature. If you are booting from live CD, you _want_ to erase
>>> any hibernation image.
>>
>> why?
>>
>> it's been stated that doing a std and booting another OS (including
>> windows) is a valid and common useage. saying that if you boot another OS
>> you trash your suspended image doesn't sound reasonable.
>
> If you hibernate your machine, boot from live cd, and change anything
> on any filesystem, you are pretty likely to loose that filesystem.

booting from a live CD doesn't mean that you are going to mount the filesystem, 
let alone change it. but swap is not supposed to be this sensitive.

David Lang

> Doing that with Windows is okay as Windows do not usually write to
> ext3 partitions.
> 									Pavel
>
