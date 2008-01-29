Return-Path: <linux-kernel-owner+w=401wt.eu-S1764667AbYA2RCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764667AbYA2RCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYA2RC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:02:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59187 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYA2RC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:02:27 -0500
Date: Tue, 29 Jan 2008 19:02:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: sections mismatches: How to mark new false positives?
Message-ID: <20080129170255.GP8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following in the latest -git:

<--  snip  -->

...
WARNING: arch/x86/kernel/built-in.o(.exit.text+0x1db): Section mismatch in reference from the function msr_exit() to the variable .cpuinit.data:msr_class_cpu_notifier
...

<--  snip  -->

That's obviously a false positive (unregister_hotcpu_notifier() is a 
noop if CONFIG_HOTPLUG_CPU=n), but how can I silence the warning?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

