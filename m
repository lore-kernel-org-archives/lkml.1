Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbXFDTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbXFDTI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbXFDTIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:08:19 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4791 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759005AbXFDTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:08:18 -0400
Message-ID: <4664632C.3050502@shadowen.org>
Date: Mon, 04 Jun 2007 20:08:28 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <20070604114110.0b88fe7a.akpm@linux-foundation.org>
In-Reply-To: <20070604114110.0b88fe7a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 04 Jun 2007 10:46:24 +0100
> Andy Whitcroft <apw@shadowen.org> wrote:
> 
>> This version brings a host of changes to cure false positives and
>> bugs detected on patches submitted to lkml and -mm.  It also brings
>> a number of new tests in response to reviews, of particular note:
>>
>>   - catch use of volatile
>>   - allow deprecated functions to be listed in feature-removal-schedule.txt
>>   - warn about #ifdef's in c files
>>   - check that spinlock_t and struct mutex use is commented
>>   - report on architecture specific defines being used
>>   - report memory barriers without an associated comment
> 
> Oy.  I ran checkpatch.pl across this patch and it failed to report upon the
> new trailing whitespace which you just tried to add.

Herm, I guess thats cause its a .pl and therefore exempt from most of
the checks.

I guess line length and white space checks make sense some degree on
those files.  I'll sort that out and I guess we'll have anohter version.
 Sounds like the #ifdef checks are too much anyhow.

-apw
