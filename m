Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbYEBPUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbYEBPUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759860AbYEBPT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:19:57 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:36132 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYEBPT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:19:56 -0400
Message-ID: <481B3115.30705@krogh.cc>
Date: Fri, 02 May 2008 17:19:49 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc> <20080501223938.921f7cd2.akpm@linux-foundation.org> <481ACEC4.2040205@krogh.cc>
In-Reply-To: <481ACEC4.2040205@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
>> I'd suspect that after 1e8 loops your CPU got too hot and started to
>> misbehave.
> 
> Hardware is an Sun Fire X4600 (8xdual-core AMD64 processors). The
> problem seem to be tied to this filesystem. (I cannot havent been able
> to reproduce it on the /-mounted disk of the same system. So if a cpu
> problem.. then it shouldn't be tied to a specific filesystem?
> 
> This is the only activity on the system .. so a load of 1 / 16cpus.

I've tried to explore this suggestion (the best I could).

There are 2 ext3 filesystems locally mounted. / and this one. Running 16 
parallel runs of this program on a file on the /-mounted filesystem 
cannot reproduce the problem. If it was linked to hot hardware, I 
believe I should be able to reproduce it this way. The servers are in a 
17 degress serverroom.

It changes alot when.. it actually happens. The "earliest ones" has been 
from 200000 cycles.

Ive tried to upgrade.. so the system is now running a 2.6.24-16-server 
(Ubuntu/Hardy) kernel. But execpt from differnet output in uname, 
everything else seems to be the same.

All suggestions/ideas are welcome? The general feeling is that it wont 
change a thing to reformat the filesystem?

Jesper
-- 
Jesper
