Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbYF3WF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbYF3WF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbYF3WFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:05:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:25446 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYF3WFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LyHDIpSLT/LoMO3SuVptf1ufgywqoPHGtInQYRqSH1F8DoD8wwG5Q5LQQu0cohEKn2
         gQd4vXiymBEvzDAINT3lq52tSy5cTL4T4DCvwFBjdm3Hy4foTRqhBDg8BihH8Jt0Wxsa
         IRFANz6dR1GpVy5coBF7efH4bsDnAjdWrBEl4=
Message-ID: <48695883.3080508@gmail.com>
Date: Mon, 30 Jun 2008 19:04:51 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>, rusty <rusty@rustcorp.com.au>,
       Bryce Harrington <bryce@canonical.com>, Ren@pimp.vs19.net
Subject: Re: [ANNOUNCE] The Linux Test Project has been Released for JUNE
 2008
References: <1214825814.4603.41.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1214825814.4603.41.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> Dear All,
> 
> The Linux Test Project test suite has been released for the month of
> JUNE 2008. The latest version of the test-suite contains 3000+ tests
> for the Linux OS and can be found at
> http://ltp.sourceforge.net/.
> Latest happenings in LTP can also be found at:
> http://ltp.sourceforge.net/wiki/,
> http://ltp.sourceforge.net/wikiArchives.php, and,
> IRC: irc.freenode.org #ltp.
> 
> 
> JUNE 2008 Highlights:
> 
> * Addition of timerfd(), utimensat(), gettid() & io_cancel() tests,
> * Addition of CPU & MEMORY HOTPLUG tests,
> * Addition of Process Event Connector tests,
> * Addition of Hackbench test,
> * RT tests fix for START_LATENCY,
> * FS_BIND fix for ia64 & for kernels below 2.6.15,
> * SE-Linux fix to build against the latest refpolicy headers,
> * Concurrency Fixes for some tests.
> 
> 
> JUNE 2008 LTP Contributors:
> 
> * Masatake YAMATO,
> * Davide Libenzi,
> * Rusty Russell,
> * Michael Kerrisk,
> * Bryce Harrington,
> * Stephen Smalley,
> * Renaud Lottiaux,
> * Vernon Mauery,
> * Louis Rilling,
> * Li Zefan,
> * Roy Lee,
> * Andrew Vagin,
> * Veerendra Chandrappa,
> * Le Rouzic,
> * Garrett Cooper,
> * Giuseppe Cavallaro,
> * Carmelo Amoroso,
> * Chirag Jog,
> * Max Stirling,
> * Shi Weihua,
> * Matthieu Fertré,
> * Matt Fleming,
> 
> 
> Note(s) from the Maintainer:
> 
> June 2008 saw the initiation of Project collaboration. Thanks to
> Masatake Yamato, who will help in porting a significant amount of
> syscall test cases from the Crackerjack Project to LTP. I am also
> excited to see that new test cases are being submitted to LTP with
> increasing pace. I hope that the pace accelerates much much more. The
> next half of 2008 will also see some major Infrastructural improvements
> in LTP along with our unending endeavor to add more test cases. From now
> onwards i would also like to acknowledge each and every contributor in
> this release mail for their valuable contribution(s). I will release
> results on 2 diff. kernels(one a bit old and another a bit younger) on
> same architecture and for those architectures available at my disposal.
> This will help us to compare results for 2 extreme kernels.
> 
> 
> Our web site also contains other information such as:
> - A Linux test tools matrix
> - Technical papers
> - How To's on Linux testing
> - Code coverage analysis tool.
> 
> We would encourage the community to post results to
> ltp-results@lists.sf.net,
> patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
> (for New Bug(s)),
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
> (for New Patch(s)),
> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
> (for New Feature Request(s))
> 
> Please also see the Change Log Attached (JUNE 2008) for detailed
> changes.
> 

Hi,

I decided to give this LTP release a try on my workstation, and there 
were quite a few test failures.  Is that expected?  I expect that some 
of the failures are probably related to kernel features I have turned 
off (I try to get rid of stuff I don't need where possible).

If the failures are not expected, what should I do?  Would the log file 
be of any help?  Are there any extra options I should supply?  I just ran:

./runltp -p -l result.yyyymmdd.log


If failures are expected on some systems or with some kernel 
configuration options, then let me know, and perhaps I can diff log 
files between kernel versions to look for new failures.

Thanks,

-- 
Kevin Winchester

