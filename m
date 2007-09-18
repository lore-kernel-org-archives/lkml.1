Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXIRLvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXIRLvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 07:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbXIRLvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 07:51:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56476 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXIRLvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 07:51:36 -0400
Subject: [LTP] Validating exact PASS and FAIL scenarios for LTP
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list@lists.sourceforge.net
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070702085054.0efb79ff.rdunlap@xenotime.net>
References: <4688A22A.2090907@linux.vnet.ibm.com>
	 <20070702085054.0efb79ff.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Tue, 18 Sep 2007 17:21:31 +0530
Message-Id: <1190116291.4763.52.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

It may be a little high time for us to visit the way LTP defines itś
PASS and FAILURES. We know that each of LTP Test cases reports certain
keywords. Now, we need to define properly how each of these Keywords
needs to be interpreted in context to the addition information these
test-cases report, so that, we can arrive at saying that:
1) this information means that TEST has passed (and in such scenario the
test-case is bound to exit(0) to pan), and,
2) That set of information means that the TEST has failed (and in such
scenario the test-case is bound to exit(non-zero) to pan)

There are several reported incidents where there is ambiguity in judging
whether the test is a PASS or FAIL. Now we have come to a point where we
need to discuss and debate this out and say that:
1) These are the situations where the test should report exit(0) to pan
irrespective of what it has reported to logs through INFO:, and,
2) These are the situations where the test should immediately terminate
with exit(non-zero) to pan.

We also need to decide where these keywords like
PASS
WARN
BROK
FAIL
RETR
CONF
INFO
should be placed, and under what context ??

I hope all of you will contribute to this debate, where we finally seal
LTP´s fate as a:
1) Broken test-suite, or,
2) a glorious one.

--Regards--
Subrata

On Mon, 2007-07-02 at 08:50 -0700, Randy Dunlap wrote:
> On Mon, 02 Jul 2007 12:28:50 +0530 Subrata Modak wrote:
> 
> >   :-) *Dear All*,
> >  
> > *Note(s) from the Maintainer: *
> > generates now and whether/how you would like it to be in future
> 
> I don't know if this qualifies as an input for the output, but
>
> ltprun-summary.sh is attached.  It uses prtag2tag.pl, which is also
> attached.  (I also do this summary SCORE for the Open Posix Test suite.)
> 
> Example summary + SCORE:
> 
> Using logfile=/cruc/runs/1789/test_output/ltp.log
> build errors:  0 lines
> PASS:          2225
> WARNing:       1
> BROKen:        1
> RETiRed:       0
> FAIL:          0
> CONFig error:  11
> SCORE.ltp:        99.5
> 
> 
> > *Please also see the ChangeLog Below (June 2007):* *
> 
> so "[PATCH] float tests: use standard test results output"
> (http://sourceforge.net/mailarchive/forum.php?thread_name=20070622214652.d137d055.rdunlap%40xenotime.net&forum_name=ltp-list)
> will be added next month?
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

