Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZBPQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZBPQNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBPQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:12:54 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56636 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZBPQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:12:53 -0500
Message-ID: <4999908D.4050403@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 17:13:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in	kernel/kallsyms.c
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu> <4999717F.7090205@s5r6.in-berlin.de> <20090216141917.GA8981@elte.hu> <499984C1.6020004@s5r6.in-berlin.de> <20090216155023.GA4422@elte.hu>
In-Reply-To: <20090216155023.GA4422@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> Ingo Molnar wrote:
>>> We routinely mention Sparse, lockdep, Coverity, Coccinelle, kmemleak, 
>>> ftrace, kmemcheck and other tools as well when it motives to fix a bug 
>>> or uncleanliness. [...] It is absolutely fine to
>>> mention checkpatch when it catches uncleanliness in code that already 
>>> got merged. I dont understand your point.
>> I wrote "don't mention checkpatch" but I really meant "think about what
>> the effect of the patch is and describe this".
> 
> Are you arguing that in all those other cases the tools should not be 
> mentioned either? I dont think that position is tenable.

I'm arguing that in all those other cases the method "think about what
the effect of the patch is and describe this"¹ applies just as well, and
that the mentioning of the tools used does not add value for future
readers of the changelog.  When I go through changes from three or five
years ago, I need other kinds of information than patch authoring tools
that were en vogue some years ago.

Including anything relevant is the most important one of the tasks when
writing a changelog; another --- only slightly less important --- task
is to exclude anything irrelevant.

Of course what's relevant and irrelevant is in the eye of the beholder;
but the used tools + materials (scripts, static analyzers, favourite
editor, favourite crop of tea) surely are of very very low relevance.

-------------
¹) and if it not quite clear, describe also why this change is desirable
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
