Return-Path: <linux-kernel-owner+w=401wt.eu-S936173AbXG1JHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936173AbXG1JHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 05:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbXG1JHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 05:07:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51946 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbXG1JHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 05:07:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AB073D.6010802@s5r6.in-berlin.de>
Date: Sat, 28 Jul 2007 11:07:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6 patch] SOFTWARE_SUSPEND: handle HOTPLUG_CPU automatically
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de> <alpine.LFD.0.999.0707271545220.3442@woody.linux-foundation.org> <20070728045247.GF15129@stusta.de>
In-Reply-To: <20070728045247.GF15129@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Jul 27, 2007 at 03:57:39PM -0700, Linus Torvalds wrote:
>> [ For extra bonus points: the SUSPEND_POSSIBLE thing is still pretty 
>>   complicated, and it might actually be a better idea to make it a 
>>   per-arch config option,
...
> This would give you "trying to assign nonexistent symbol SUSPEND_POSSIBLE"
> kconfig warnings on architectures without SUSPEND_POSSIBLE.

Unless /all/ architectures define it, of course.
-- 
Stefan Richter
-=====-=-=== -=== ===--
http://arcgraph.de/sr/
