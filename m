Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbXLJVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbXLJVa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXLJVaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:30:20 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:47373 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752729AbXLJVaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:30:18 -0500
Message-ID: <475DAFE9.7040700@cfl.rr.com>
Date: Mon, 10 Dec 2007 16:30:17 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Evgeniy.Polyakov@vax.1wt.eu
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Evgeniy Polyakov
			^-extraneous tokens in address
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Evgeniy Polyakov
			^-extraneous tokens in address
Subject: Re: syslets v7: back to basics
References: <1196983219534-git-send-email-zach.brown@oracle.com>
In-Reply-To: <1196983219534-git-send-email-zach.brown@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2007 21:30:31.0952 (UTC) FILETIME=[E46A7900:01C83B73]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15598.001
X-TM-AS-Result: No--6.212700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> The following patches are a substantial refactoring of the syslet code.  I'm
> branding them as the v7 release of the syslet infrastructure, though they
> represent a signifiant change in focus.
> 
> My current focus is to see the most fundamental functionality brought to
> maturity.  To me, this means getting a ABI that is used by applications through
> glibc on x86 and PPC64.   Only once that is ready should we distract ourselves
> with advanced complexity.

I pulled from your tree to look over the patches, and noticed that it 
looks like several commits were merged improperly.  It looks like they 
were auto merged or something from an email, and the commit message 
contains the email headers, rather than just the commit message in the 
body.  This leads to the shortlog showing entries that start with 
"Return-Path:".

I was hoping to find at least some initial information on the overall 
design in Documentation/ but don't see any.  Have you written any yet 
that I could take a look at elsewhere maybe?

Some of the things I was trying to figure out is does each syslet get 
its own stack, and schedule only at a few well defined points, and if 
so, would it then be fair to characterize them as kernel mode fibers?
