Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYGGNT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYGGNT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYGGNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:19:50 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34266 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYGGNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:19:49 -0400
Message-ID: <487217E1.2040205@s5r6.in-berlin.de>
Date: Mon, 07 Jul 2008 15:19:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: =?ISO-8859-2?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
References: <20080704063455.GA13999@digi.com>	<200807040852.27809.oliver@neukum.org>	<m3k5g1zv3u.fsf_-_@maximus.localdomain>	<20080704134426.GA32700@digi.com> <m37ic1zqqp.fsf@maximus.localdomain>
In-Reply-To: <m37ic1zqqp.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com> writes:
> 
>> Why not make that a script that parses MAINTAINERS and lives in scripts/
>> and that can be used as --cc-cmd to git-send-email?  Then no service
>> needs to be maintained, you don't get the observers functionality
>> though.  (But that's what mailing lists are good for.)
>>
>> Of course MAINTAINERS needs to be modified to have the path specifiers.
> 
> Because then:
> - the action is not effective immediately but sometimes after few
>   months, not counting people still working with 2.6.12 or so.

We expect submissions to based on something more recent than 2.6.12.

Your patch service however...

> - IMHO adding Cc: patch-service is a bit easier than using a script
> - I think the "observers" thing is worth the effort. Now I only see
>   changes to certain areas I'm interested in when they are accepted
>   upstream.
> - maintaining the script is probably more work than maintaining the
>   database :-)
> 
> And with a service you can:
> - maintain a patch archive
> - be sure nobody tries to be "creative"
> - perhaps other things I haven't thought about.

...already exists.  Check the "L:" entries in MAINTAINERS.
-- 
Stefan Richter
-=====-==--- -=== --===
http://arcgraph.de/sr/
