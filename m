Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbXFEJ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbXFEJ4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764286AbXFEJ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:56:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1495 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764275AbXFEJ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:56:27 -0400
Message-ID: <4665334F.3060703@shadowen.org>
Date: Tue, 05 Jun 2007 10:56:31 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: jschopp <jschopp@austin.ibm.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
References: <0a25fd03117c678f17006c5fcefaaed0@pinky> <466434A1.4040905@austin.ibm.com>
In-Reply-To: <466434A1.4040905@austin.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jschopp wrote:
>> This version brings a host of changes to cure false positives and
>> bugs detected on patches submitted to lkml and -mm.  It also brings
>> a number of new tests in response to reviews, of particular note:
>>
>>   - catch use of volatile
>>   - allow deprecated functions to be listed in
>> feature-removal-schedule.txt
>>   - warn about #ifdef's in c files
> 
> 
> I think the design philosophy of the style checker should be to err on
> the side of being quiet.  It shouldn't report things that aren't
> problems.  There are plenty of valid uses of #ifdefs in c files. 
> #ifdefs may be abused often.  If we start bothering every author that
> uses #ifdefs with an annoying note it detracts from the usefulness of
> our tool.
> 
> If we really want to complain about #ifdefs we should add a flag to the
> script so it isn't a default.  -potential or something.  We could put
> all the "this often is an error" type warnings under it.
> 
> The rest of the patch looks fine.

For now then we'll put the ifdef checks on ice until we get a better
idea of the "rules" if we ever do.

-apw

