Return-Path: <linux-kernel-owner+w=401wt.eu-S1764146AbXG2QDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764146AbXG2QDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761410AbXG2QDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:03:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58147 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbXG2QDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:03:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46ACBA2B.6080401@s5r6.in-berlin.de>
Date: Sun, 29 Jul 2007 18:02:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: nvidia installer DIW with 2.6.23-rc1
References: <200707291057.34291.gene.heskett@gmail.com> <Pine.LNX.4.64.0707291710440.9488@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707291710440.9488@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 29 2007 10:57, Gene Heskett wrote:
>>   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c: In 
>> function
>>   ‘nvidia_init_module’:
>>   /tmp/selfgz9678/NVIDIA-Linux-x86-100.14.11-pkg1/usr/src/nv/nv.c:1326: 
>> error:
>>   too many arguments to function ‘kmem_cache_create’
...
> Fix the source until they have a fix. It seems to be
> just an extra argument to kmem_cache_create that got removed.

Gene,
the last argument to kmem_cache_create has been removed.  It should be
a simple matter to delete it from the caller, since it already was
unsupported by the callees in previous kernels.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=20c2df83d25c6a95affe6157a4c9cac4cf5ffaac
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdiff;f=mm/slab.c;h=bde271c001ba33ef1f61dd0f563f74d319cd1f0e;hp=c3feeaab387537ef00aa2085b4f54f6d7e4abca0
-- 
Stefan Richter
-=====-=-=== -=== ===-=
http://arcgraph.de/sr/
