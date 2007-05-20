Return-Path: <linux-kernel-owner+w=401wt.eu-S1761958AbXETACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958AbXETACo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXETACh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:02:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33781 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbXETACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:02:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464F900A.10900@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 02:02:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Petr Vandrovec <petr@vandrovec.name>, dan@dennedy.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
References: <20070507021447.GA22197@vana.vc.cvut.cz> <200705200155.26825.arnd@arndb.de>
In-Reply-To: <200705200155.26825.arnd@arndb.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 07 May 2007, Petr Vandrovec wrote:
>> +struct raw1394_cycle_timer32 {
>> +        __u32 cycle_timer;
>> +        __u64 local_time;
>> +} __attribute__((packed));
> 
> Note that this data structure only needs conversion on x86_64 and ia64, but
> not on powerpc and other 64 bit architectures that align __u64 also in
> 32 bit mode.

Is this conversion just unnecessary or actually harmful on ppc64 and others?
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
