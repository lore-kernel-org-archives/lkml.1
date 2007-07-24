Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXGXN6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXGXN6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXGXN6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:58:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50291 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbXGXN6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:58:32 -0400
Message-ID: <46A60581.90800@austin.ibm.com>
Date: Tue, 24 Jul 2007 08:58:25 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com>
In-Reply-To: <46A53F3A.7060509@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> within the last 3 weeks, this script went from *really usable* to *a big 
> noise maker*.

As we (mostly Andy of late) add more checks (good) there is bound to be some code we just 
didn't forsee that generates false positives (bad).  You can see a consistent history of 
cleaning these up as quickly as people send them in.  Hopefully in the interim there 
aren't too many false positives and the script is still useful.  We do try to put the new 
tests through their paces before adding them in, but our imaginations are limited.

The goal has always been to err on the side of missing badness in code to avoid false 
positives. This way, when there is output it has a very high chance of not wasting your 
time.  Wait a couple weeks and it'll be there again.

> Bottom line: I really wish that I could have the script run in the old 
> behaviour before. While this level of verbosity is great for single-line 
> patches, it really completely wastes my time when I'm trying to get a 
> grasp for a 200k hunk piece of code.

I think it would be a great idea to have the script default to very conservative behavior 
and have a flag say --verbose to turn on checks that have a higher false positive rate 
(such as the multiple variable declarations per line).  This might also be a staging area 
for newer checks to get a chance to work out some kinks before being added to the default.
