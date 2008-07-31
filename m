Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYGaRzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYGaRzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYGaRzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:55:08 -0400
Received: from main.gmane.org ([80.91.229.2]:41629 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYGaRzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:55:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: malc@pulsesoft.com
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
Date: Thu, 31 Jul 2008 04:42:16 +0400
Message-ID: <87bq0evq8n.fsf@linmac.oyster.ru>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <84144f020807301522r7fb97bfehe0fcdceef10477b9@mail.gmail.com> <alpine.LFD.1.10.0807301529190.3277@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 83.167.112.74
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
Cancel-Lock: sha1:oAQsqVl0b4FyVuipp5rFoO/LjsA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 31 Jul 2008, Pekka Enberg wrote:
>> 
>> Oh, I didn't suggest this for merging. Just thought you'd be
>> interested to know that best-fit doesn't really do that much better
>> than what we have in the tree now. (Well, I was kinda hoping you'd
>> tell me why my implementation is wrong and you were right all along.)
>
> Heh. Most allocators tend to work pretty well under normal load, and the 
> real fragmentation problems all tend to happen under special patterns. The 
> one in glibc, for example, sucks donkey dick when using threading, but is 
> apparently ok otherwise. 
>
> I wouldn't actually expect most "normal" kernel use to show any really bad 
> patterns on any normal loads. Google for
>
> 	worst-case first-fit fragmentation
>
> (or 'next-fit' for that matter) to see some stuff. Of course, it is scary 
> only if you can trigger it in practice (perhaps with certains games on 
> packet size, or creating/removing files with pathname size patterns ec).
>
> [ Of course, google probably mostly returns hits from all those ACM 
>   portals etc. I wonder why google does that - they're almost totally 
>   useless search results. Sad. If somebody knows how to turn those ACM 
>   pay-portals off in google, pls let me know ]
>
> 			Linus

blahblah -site:portal.acm.org ?

-- 
mailto:av1474@comtv.ru

