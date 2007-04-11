Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXDKRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXDKRGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 13:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXDKRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 13:06:33 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:58387 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXDKRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 13:06:32 -0400
Date: Wed, 11 Apr 2007 19:05:38 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <461D1291.2060703@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0704111903300.20436@yvahk01.tjqt.qr>
References: <200704110112.39425.a1426z@gawab.com>
 <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr> <200704110742.38727.a1426z@gawab.com>
 <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr> <461D1291.2060703@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 18:53, Stefan Richter wrote:
>Jan Engelhardt wrote:
>> On Apr 11 2007 07:42, Al Boldi wrote:
>>>Also, I don't think it's necessary to touch any of the "depends on"; keep 
>>>them as is, as they don't hurt staying that way, and may actually be 
>>>necessary under certain circumstances.  (see EMBEDDED)
>> 
>> Simplifying the depends lines is a good thing IMO.
>
>If explicit dependency statements are replaced by if--endif blocks, does
>this count as simplification?

According to Documentation/kbuild/, if FOO .. endif is interpreted as if
each option inside the if block had 'depends on FOO'.

If _every_ option under a menu (and that's another reason why I did not
modify _all_ Kconfig menus) has a 'depends on this or that', it can
be substituted by an if block, and yes, I take that as a simplification
since the whole LoC count goes down. What would perhaps be cool is
some indent in Kconfig to see what an if-endif block spans, but currently
this is not much needed, since two nested ifs are quite the max.

Jan
-- 
