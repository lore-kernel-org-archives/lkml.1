Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXGXSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXGXSii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXGXSib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:38:31 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4347 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXGXSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:38:30 -0400
Message-ID: <46A6471F.1090003@shadowen.org>
Date: Tue, 24 Jul 2007 19:38:23 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com> <46A5E39D.7030009@shadowen.org> <Pine.LNX.4.64.0707241854140.18990@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707241854140.18990@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 24 2007 12:33, Andy Whitcroft wrote:
>>> Warning on multiple declarations on a line is nice, but IMO really too
>>> verbose (why is "int i, j;" bad? Did C somehow change syntax today?).
>> No the normal response is two fold:
>>
>> 1) "what the heck are i and j those are meaningless names"
> 
> Can we at least assume the submitter is sane in some ways?
> i and j are picked for obvious iterater values - you would not want
> verbosify that to fruit_iterator and process_iterator or whatever
> because it's a hell lot more typing.
> It takes more than a few Perl regexes to actually grasp the semantics
> of whether "i" is useful or not.

I was mearly quoting the what I'd seen.  I am completely ambivalent on
the whole process.  I had assumed when we updated the documentation to
strongly indicate that this was a style guide not a robot with patch
veto power that people would realise they could ignore those things they
disagreed with and things would be good.	

checkpatch is only intended to tell you what a Reviewer is likely to
pick up and winge about and is intended to save _them_ time, their time
generally being more limited that yours if for no other reason than you
want your patch in, and they may have no vested interest.

That said I want it to be as unannoying as we can and we will have
loosened most of the checks you do not like in the next release.

-apw

