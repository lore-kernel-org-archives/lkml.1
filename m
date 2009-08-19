Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170AbZHSBML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbZHSBML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 21:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZHSBML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 21:12:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbZHSBMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 21:12:10 -0400
Message-ID: <4A8B5113.20102@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 09:10:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com>
In-Reply-To: <4A8B4607.6090303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> BTW, how did you get the dmesg? Is it from a clean boot?
>>
>> Since it works fine in -rc5 but breaks in -rc6, could you do a git bisect
>> on it? It shouldn't take too long.
>>
>> Thanks,
>>
>> -- Steve
>>
>>    
> well grub2 sure works o.k.
> the new gfxload is pretty good.
> problem is the screen just says
> [Linux-bzImage etc.....]
> and that's it. (was hoping to make the
> font smaller to reveal the bug).
> 
> at this point the only choice I have is to undo
> commits until I hit the right one.
> 

You still can do bisect manually. or use quilt?

