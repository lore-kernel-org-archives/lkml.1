Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYFJLuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYFJLuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYFJLuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 07:50:05 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:59400 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYFJLuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:50:04 -0400
Message-ID: <484E6A68.4060203@aitel.hist.no>
Date: Tue, 10 Jun 2008 13:50:00 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2  compile error in vmscan.c
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
In-Reply-To: <20080609223145.5c9a2878.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
> 
> - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
>   vmscan.c bug which would have prevented testing of the other vmscan.c
>   bugs^Wchanges.
> 

Interesting to try out, but I got this:

  $ make
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   CC      mm/vmscan.o
mm/vmscan.c: In function 'show_page_path':
mm/vmscan.c:2419: error: 'struct mm_struct' has no member named 'owner'
make[1]: *** [mm/vmscan.o] Error 1
make: *** [mm] Error 2


I then tried to configure with "Track page owner", but that did not 
change anything.

Helge Hafting
