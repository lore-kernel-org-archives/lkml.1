Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbYKFFnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbYKFFnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 00:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYKFFnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 00:43:11 -0500
Received: from smtp.nokia.com ([192.100.122.230]:41497 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYKFFnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 00:43:09 -0500
Message-ID: <4912836B.5040900@yandex.ru>
Date: Thu, 06 Nov 2008 07:40:59 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind@infradead.org>
Subject: Re: [PATCH] ubifs: fix printk format warnings
References: <20081104204652.f8eb37a0.randy.dunlap@oracle.com>
In-Reply-To: <20081104204652.f8eb37a0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Nov 2008 05:42:30.0371 (UTC) FILETIME=[757F0330:01C93FD2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in ubifs.
> Built cleanly on 7 arches.
> 
> fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/journal.c:1131: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/dir.c:163: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/tnc.c:2680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/tnc.c:2700: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/replay.c:1066: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'ino_t'
> fs/ubifs/orphan.c:108: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:135: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:142: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:154: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:159: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:451: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:539: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:612: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:843: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:856: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1438: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1443: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1475: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1495: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:1591: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1671: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1674: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1699: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1788: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1821: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1833: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1924: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1932: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1938: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1945: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1953: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1967: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1973: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1988: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1991: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:2009: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ino_t'
> 

Thanks for the patch, but I've already done that after your original messages. I replied
that I'll fix this, and so did I:

http://git.infradead.org/users/dedekind/ubifs-2.6.git?a=commit;h=e359eb766b03ae6194d6a6721b5f88c16b074361

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
