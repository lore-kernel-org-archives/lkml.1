Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0BBIaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:30:25 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:50086 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0BBIaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wAW3KqwFT1DJcys7XAD+Ee6HUxKeLqCfR2otFHwLAel5Q8G6CkGiF0X1G9kqrZSK+n
         1J9bJFAzbYyLntuGBFD1pmhhgoRVegVofX5XAlX65I9gK5qSKnI0SntKr0KqNc2A0xXh
         V1sB/5SAauE+mJveB61+niEJOAT0ImT2YZqbk=
MIME-Version: 1.0
Date: Tue, 2 Feb 2010 00:30:23 -0800
Message-ID: <364299f41002020030u527224adsb87f33ba4119551c@mail.gmail.com>
Subject: [IMPORTANT] Clean target regression [was Re: [ANNOUNCE] The Linux 
	Test Project has been released for JANUARY 2010]
From: Garrett Cooper <yanegomi@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 8:01 AM, Garrett Cooper <yanegomi@gmail.com> wrote:
> On Mon, Feb 1, 2010 at 2:57 AM, Subrata Modak
> <subrata@linux.vnet.ibm.com> wrote:
>> Hi,
>>
>> The Linux Test Project test suite has been released for the month of
>> JANUARY 2010. Please see ltp/INSTALL file carefully, as, there has
>> been multiple changes for building/installing the test suite after the
>> recent changes in Makefile infrastructure.
>>
>> The latest version of the test-suite contains 3000+ tests for the Linux
>> OS and can be found at:
>> http://ltp.sourceforge.net/,
>> Latest happenings in LTP can also be found at:
>> http://ltp.sourceforge.net/wiki/,
>> http://ltp.sourceforge.net/wikiArchives.php, and,
>> IRC: irc.freenode.org #ltp.
>>
>> Our web site also contains other information such as:
>> - A Linux test tools matrix
>> - Technical papers
>> - How To's on Linux testing
>> - Code coverage analysis tool.
>>
>> We would encourage the community to post results to
>> ltp-results@lists.sf.net,
>> patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
>> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
>> New Bug(s)),
>> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
>> New Patch(s)),
>> http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
>> New Feature Request(s))
>>
>> **Note: Some pending patches will be checked in for next monthś release.
>
>    For those who have been holding off on upgrading since the Make
> infrastructure revision was done back in October, I highly suggest
> that they evaluate this release as a several issues have been
> resolved, i.e. selinux-testsuite being fixed to meet the make
> infrastructure changes (there's just a minor issue that's been
> reported on RHEL 5.4 with the policy files -- Stephen should be
> working with Mitani-san to resolve the issue), and a few autoconf
> related items have been resolved. Furthermore, make 3.80 support has
> been integrated into the project so folks can once again use make 3.80
> when building LTP.
> All the best,

    NOTE -- please comment out the following three lines in the
top-level Makefile -- not doing so will result in you potentially
obliterating all of the writable files on your build target, as this
will effectively perform an rm -Rf / under certain conditions.

ifeq ($(filter $(BUILD_TREE_STATE),$(BUILD_TREE_SRCDIR_INSTALL)
$(BUILD_TREE_UNCONFIGURED)),)
CLEAN_TARGETS        += clean_install_dir
endif

    I deeply apologize for the inconvenience; I'm working on
rectifying the issue ASAP and will email again once it's resolved; I
will add a regression test for this ASAP in the build test scripts
I've recently authored so this doesn't happen again.
Thanks,
-Garrett
