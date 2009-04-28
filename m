Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbZD1NFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbZD1NFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbZD1NFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:05:22 -0400
Received: from galaxy-old.riz.pl ([195.94.202.2]:34004 "HELO vhost.riz.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758934AbZD1NFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:05:20 -0400
Date: Tue, 28 Apr 2009 15:05:17 +0200 (CEST)
From: Bart <mmx@riz.pl>
X-X-Sender: evil@galaxy.riz.pl
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13112] Oops in drain_array
In-Reply-To: <alpine.DEB.1.10.0904271337450.31916@qirst.com>
Message-ID: <Pine.LNX.4.64.0904281444220.2455@galaxy.riz.pl>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>  <egHshlwQQFE.A.KjC.JpE9JB@chimera>
  <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com>
 <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com>
 <alpine.DEB.1.10.0904271000200.16119@qirst.com> <Pine.LNX.4.64.0904271849590.2455@galaxy.riz.pl>
 <alpine.DEB.1.10.0904271337450.31916@qirst.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Christoph Lameter wrote:

> On Mon, 27 Apr 2009, Bart wrote:
>
>> Apr 27 16:57:30 fs kernel: [   96.446708] slab error in verify_redzone_free():
>> cache `size-128': memory outside object was overwritten
>
> Allright so a write after or before a 128 byte kmalloc object. Can
> you switch to the SLUB allocator so that we can get memory dumps of
> the corruption which will help to diagnose this further?

After switching to SLUB I had a complete hard freeze when trying to 
reproduce the error. I've got a photo of the screen but I dont know if it 
is usefull so I did not copied it to txt:

http://bz.riz.pl/IMAG0032.jpg

-- 
  Regards
  Bart mmx@riz.pl
