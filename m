Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYGBOWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYGBOWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYGBOWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:22:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36780 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYGBOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:22:17 -0400
Subject: Re: [ANNOUNCE] The Linux Test Project has been Released for JUNE
	2008
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>, rusty <rusty@rustcorp.com.au>,
       Bryce Harrington <bryce@canonical.com>, Ren@pimp.vs19.net
In-Reply-To: <48695883.3080508@gmail.com>
References: <1214825814.4603.41.camel@subratamodak.linux.ibm.com>
	 <48695883.3080508@gmail.com>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Wed, 02 Jul 2008 19:52:00 +0530
Message-Id: <1215008520.4885.59.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 19:04 -0300, Kevin Winchester wrote:
> Subrata Modak wrote:
> > Dear All,
> > 
> > The Linux Test Project test suite has been released for the month of
> > JUNE 2008. The latest version of the test-suite contains 3000+ tests
> > for the Linux OS and can be found at
> > http://ltp.sourceforge.net/.
> > Latest happenings in LTP can also be found at:
> > http://ltp.sourceforge.net/wiki/,
> > http://ltp.sourceforge.net/wikiArchives.php, and,
> > IRC: irc.freenode.org #ltp.
> > 
> > 
> > JUNE 2008 Highlights:
> > 
> > * Addition of timerfd(), utimensat(), gettid() & io_cancel() tests,
> > * Addition of CPU & MEMORY HOTPLUG tests,
> > * Addition of Process Event Connector tests,
> > * Addition of Hackbench test,
> > * RT tests fix for START_LATENCY,
> > * FS_BIND fix for ia64 & for kernels below 2.6.15,
> > * SE-Linux fix to build against the latest refpolicy headers,
> > * Concurrency Fixes for some tests.
> > 
> > 
> > JUNE 2008 LTP Contributors:
> > 
> > * Masatake YAMATO,
> > * Davide Libenzi,
> > * Rusty Russell,
> > * Michael Kerrisk,
> > * Bryce Harrington,
> > * Stephen Smalley,
> > * Renaud Lottiaux,
> > * Vernon Mauery,
> > * Louis Rilling,
> > * Li Zefan,
> > * Roy Lee,
> > * Andrew Vagin,
> > * Veerendra Chandrappa,
> > * Le Rouzic,
> > * Garrett Cooper,
> > * Giuseppe Cavallaro,
> > * Carmelo Amoroso,
> > * Chirag Jog,
> > * Max Stirling,
> > * Shi Weihua,
> > * Matthieu Fertré,
> > * Matt Fleming,
> > 
> > 
> > Note(s) from the Maintainer:
> > 
> > June 2008 saw the initiation of Project collaboration. Thanks to
> > Masatake Yamato, who will help in porting a significant amount of
> > syscall test cases from the Crackerjack Project to LTP. I am also
> > excited to see that new test cases are being submitted to LTP with
> > increasing pace. I hope that the pace accelerates much much more. The
> > next half of 2008 will also see some major Infrastructural improvements
> > in LTP along with our unending endeavor to add more test cases. From now
> > onwards i would also like to acknowledge each and every contributor in
> > this release mail for their valuable contribution(s). I will release
> > results on 2 diff. kernels(one a bit old and another a bit younger) on
> > same architecture and for those architectures available at my disposal.
> > This will help us to compare results for 2 extreme kernels.
> > 
> > 
> > Our web site also contains other information such as:
> > - A Linux test tools matrix
> > - Technical papers
> > - How To's on Linux testing
> > - Code coverage analysis tool.
> > 
> > We would encourage the community to post results to
> > ltp-results@lists.sf.net,
> > patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
> > http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382
> > (for New Bug(s)),
> > http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382
> > (for New Patch(s)),
> > http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382
> > (for New Feature Request(s))
> > 
> > Please also see the Change Log Attached (JUNE 2008) for detailed
> > changes.
> > 
> 
> Hi,
> 
> I decided to give this LTP release a try on my workstation, and there 

Thanks for starting to use LTP.

> were quite a few test failures.  Is that expected?  I expect that some

Failures can be for various reasons. May be you have hit a kernel bug.
But yes, there may be reasons for the corresponding support not being
available in the Kernel.

> of the failures are probably related to kernel features I have turned 
> off (I try to get rid of stuff I don't need where possible).
> 
> If the failures are not expected, what should I do?  Would the log file 
> be of any help?  Are there any extra options I should supply?  I just ran:

You can try to use:

./runltp -h

for all options that you would like to use. If you like you can also use
the:
./runltp -g <html-filename.html>

option to generate a swanky HTML output file, which will help you to
decipher the exact reason for failure. You can also see the normal test
output file, from where the HTML is parsed out at ltp/output directory.
This will be available after the tests are complete.

Meanwhile i will request you to give a try to the following test results
that were uploaded to the site for the latest release. I tried to
generate results for various architectures and kernel combinations. The
file names are self explanatory. You can compare them with yours.

http://ufpr.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.16.21-0.8-default_architecture-ia64.html
http://surfnet.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.18-48.el5_architecture-ppc64.html
http://switch.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.18-92.el5_architecture-x86_64.html
http://ufpr.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.23.13_architecture-ia64.html
http://ufpr.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.25-gcov-nomodconfig-smp_architecture-i386.html
http://switch.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.5-7.244-pseries64_architecture-ppc64.html
http://internap.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.7_architecture-i386.html
http://master.dl.sourceforge.net/sourceforge/ltp/ltp-full-20080630_results_kernel-2.6.9-67.ELsmp_architecture-x86_64.html

Regards--
Subrata

> 
> ./runltp -p -l result.yyyymmdd.log
> 
> 
> If failures are expected on some systems or with some kernel 
> configuration options, then let me know, and perhaps I can diff log 
> files between kernel versions to look for new failures.
> 
> Thanks,
> 

