Return-Path: <linux-kernel-owner+w=401wt.eu-S933775AbXHFXMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbXHFXMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764567AbXHFXMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:12:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:44452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762192AbXHFXMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:12:20 -0400
In-Reply-To: <200708070034.19193.m.kozlowski@tuxland.pl>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708062134.16643.m.kozlowski@tuxland.pl> <236b147ed4a92945baa3c6b29e7e5f31@kernel.crashing.org> <200708070034.19193.m.kozlowski@tuxland.pl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <14f932ea857d563d409cc10b570fc085@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-usb-devel@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: 2.6.23-rc1-mm2
Date: Tue, 7 Aug 2007 01:12:00 +0200
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> It seems like things go wrong when lparmap.s is generated with
>> (DWARF) debug info; could you try building it (manually) with -g0
>> added on the end of the compile line, and see if head_64.o compiles
>> okay for you then?  If so, I'll prepare a proper patch for it, I
>> have a similar one (also for lparmap!) in my queue already...
>
> Ok it worked. I had to add -g0 to Makefile under arch/powerpc/kernel 
> because
> -g0 was added before -g and didn't have any effect when adding to 
> Makefile
> in top dir.

Yeah, that's why I said "build lparmap.s manually" :-)

> But yes - it compiles now.

Great, I'll combine it with my other lparmap build patch then.
Thanks for the report and testing!


Segher

