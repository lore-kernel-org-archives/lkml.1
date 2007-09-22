Return-Path: <linux-kernel-owner+w=401wt.eu-S1761712AbXIVJTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712AbXIVJTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 05:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXIVJTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 05:19:48 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45178 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbXIVJTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 05:19:47 -0400
Date: Sat, 22 Sep 2007 11:19:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrey Mirkin <amirkin@sw.ru>, John McCutchan <ttb@tentacle.dhs.org>,
       Robert Love <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@osdl.org>,
       devel@openvz.org
Subject: Re: [PATCH] change inotifyfs magic as the same magic is used for
 futexfs
In-Reply-To: <20070921085313.39717ba4.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0709221119340.15712@fbirervta.pbzchgretzou.qr>
References: <200709211735.44814.amirkin@sw.ru> <20070921085313.39717ba4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 21 2007 08:53, Randy Dunlap wrote:
>On Fri, 21 Sep 2007 17:35:43 +0400 Andrey Mirkin wrote:
>
>> From: Andrey Mirkin <major@openvz.org>
>> 
>> Right now futexfs and inotifyfs have one magic 0xBAD1DEA, that looks a little 
>> bit confusing.
>> Use 0xBAD1DEA as magic for futexfs and 0x2BAD1DEA as magic for inotifyfs.
>> 
>> Signed-off-by: Andrey Mirkin <major@openvz.org>
>
>A 'diffstat -p 1 -w 70' would be helpful so we can see which files
>are touched.
>
>Please add these magic numbers to include/linux/magic.h so that
>they are clearly visible and conflicts can be seen easier,
>then #include <linux/magic.h> in these source files.

Also because userspace may want these magics too.


