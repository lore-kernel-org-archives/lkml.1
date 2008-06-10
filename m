Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYFJMXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYFJMXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYFJMXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:23:31 -0400
Received: from saeurebad.de ([85.214.36.134]:34014 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYFJMXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:23:30 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2  compile error in vmscan.c
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<484E6A68.4060203@aitel.hist.no>
Date: Tue, 10 Jun 2008 14:23:26 +0200
In-Reply-To: <484E6A68.4060203@aitel.hist.no> (Helge Hafting's message of
	"Tue, 10 Jun 2008 13:50:00 +0200")
Message-ID: <87hcc1jx6p.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Helge Hafting <helge.hafting@aitel.hist.no> writes:

> Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
>>
>> - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
>>   vmscan.c bug which would have prevented testing of the other vmscan.c
>>   bugs^Wchanges.
>>
>
> Interesting to try out, but I got this:
>
>  $ make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      mm/vmscan.o
> mm/vmscan.c: In function 'show_page_path':
> mm/vmscan.c:2419: error: 'struct mm_struct' has no member named 'owner'
> make[1]: *** [mm/vmscan.o] Error 1
> make: *** [mm] Error 2
>
>
> I then tried to configure with "Track page owner", but that did not
> change anything.

CONFIG_PAGE_OWNER is something else, owner is only active if
CONFIG_MM_OWNER is set.

	Hannes
