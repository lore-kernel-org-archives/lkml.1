Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXGXOzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXGXOzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbXGXOyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:54:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4009 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbXGXOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:54:52 -0400
Message-ID: <46A611D3.3070808@shadowen.org>
Date: Tue, 24 Jul 2007 15:50:59 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: jschopp <jschopp@austin.ibm.com>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com> <46A60581.90800@austin.ibm.com> <20070724143342.GB6019@stusta.de>
In-Reply-To: <20070724143342.GB6019@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Jul 24, 2007 at 08:58:25AM -0500, jschopp wrote:
>>> within the last 3 weeks, this script went from *really usable* to *a big 
>>> noise maker*.
>> As we (mostly Andy of late) add more checks (good) there is bound to be 
>> some code we just didn't forsee that generates false positives (bad).  You 
>> can see a consistent history of cleaning these up as quickly as people send 
>> them in.  Hopefully in the interim there aren't too many false positives 
>> and the script is still useful.  We do try to put the new tests through 
>> their paces before adding them in, but our imaginations are limited.
>>
>> The goal has always been to err on the side of missing badness in code to 
>> avoid false positives. This way, when there is output it has a very high 
>> chance of not wasting your time.  Wait a couple weeks and it'll be there 
>> again.
>> ...
> 
> And it will be known as "noise maker" for years, even if that'll be 
> fixed in a few weeks...
> 
> Running it on the latest -rc or -mm should usually give good hints 
> whether the output has become better or worse.

I generally run a new release against all incoming patches on lkml for a
few days before releasing.  The latest problem ones have been caused by
a difference of opinion on what the CodingStyle means or about what the
"best" style for a few things.  Multiple initialisation etc being good
examples.

There is no way to test for "what the majority will dissagree with".

-apw
