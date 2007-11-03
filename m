Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbXKCJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbXKCJ5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXKCJ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:57:13 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35323
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXKCJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:57:12 -0400
Date: Sat, 3 Nov 2007 03:05:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rik van Riel <riel@surriel.com>
cc: Valdis.Kletnieks@vt.edu, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: <20071102233615.6dc90e35@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711030300040.4780@asgard.lang.hm>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071028180707.GA6111@ucw.cz>
 <20071029194820.GC27646@csclub.uwaterloo.ca> <20071029201911.GB3537@elf.ucw.cz>
 <20071029214452.GA27643@csclub.uwaterloo.ca> <12100.1194059303@turing-police.cc.vt.edu>
 <20071102233615.6dc90e35@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007, Rik van Riel wrote:

> On Fri, 02 Nov 2007 23:08:23 -0400
> Valdis.Kletnieks@vt.edu wrote:
>
>> IBM's AIX supported file system compression on the JFS filesystem
>> years ago. I was able to get up to 30% throughput increases by
>> converting the /usr filesystem to compressed - because even a 33mhz
>> Power chipset could read in 5 512-byte blocks and decompress it to
>> the original 4K faster than the disk could read in 8 512-byte
>> blocks.
>
>> Given that today there's an even *bigger* disparity in CPU speed
>> versus disk speed, I'd be surprised if it doesn't help today too.
>
> The problem is that disk seek times have not gotten much
> faster over the years, while disk throughput rates have
> skyrocketed.
>
> Transferring a little less data is not going to help you
> when 80% of your disk time is spent seeking, not reading
> or writing.

however, if you can manage to avoid seeks by packing more data onto each 
track (or each stripe of a raid array) you could probably see a 
significant win

that's something for aspiring (and experianced) filesystem designers to 
struggle with for a while (especially trying to figure out what the size 
of a track or stripe is for the optimal layout)

David Lang
