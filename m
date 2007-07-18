Return-Path: <linux-kernel-owner+w=401wt.eu-S935594AbXGRSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594AbXGRSms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbXGRSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:42:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXGRSmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:42:40 -0400
Date: Wed, 18 Jul 2007 20:42:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@stusta.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
In-Reply-To: <20070718183359.GK3801@stusta.de>
Message-ID: <Pine.LNX.4.64.0707182037180.5385@fbirervta.pbzchgretzou.qr>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de>
 <469E3806.4030804@zytor.com> <20070718183359.GK3801@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18 2007 20:33, Adrian Bunk wrote:
>> Well, how big the vmlinux file is matters if it doesn't fit in memory
>> with enough time to get to the phase where it is dumping the init
>> sections.  *If that is not the issue*, then axing stuff like CPUID is a
>> major lose in terms of code maintainability for zero gain.
>
>If this is an issue, then changing i386 back to discarding __exit code 
>and data at linktime instead of runtime might make a bigger difference.

Would not that be good in either case? (I.e. even beyond i386)
Discarding __exit at the linking stage for CONFIG_MODULES=n kernels
sounds really good, because it reduces the time to _load_ the kernel.
Think TFTP. Particularly SPARC OBPs (I've seen E250 and E10K do that)
do TFTP transfers like an old granny ... You wait roughly two minutes
for common Aurora and Debian images (around 6 to 7 MB) - to get the
picture. I am grateful for every kilobyte images can lose.



	Jan
-- 
