Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbXIDVkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbXIDVkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXIDVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:39:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXIDVj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:39:58 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Chuck Ebbert <cebbert@redhat.com>, linux-acpi@vger.kernel.org
Subject: Re: What's happening with the cpuidle code?
Date: Tue, 4 Sep 2007 17:43:47 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adam Belay <abelay@novell.com>
References: <46DDC462.2040309@redhat.com>
In-Reply-To: <46DDC462.2040309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041743.47837.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 16:47, Chuck Ebbert wrote:
> A look at the 'cpuidle' branch of git-acpi shows a commit
> e40cede7d63a029e92712a3fe02faee60cc38fb4, "cpuidle: first
> round of documentation updates" that doesn't show up in that
> branch online. The entire Documentation/cpuidle directory
> is missing from the tree when looking at the web pages, and
> it's missing from git-acpi.patch in 2.6.23-rc4-mm1 (but the
> patch shows up in the summary information in the patch
> header.) Where did it go? And how can -mm be used to test
> things if its patches don't even match their own headers?

A later patch in that series, "cpuidle: re-write", reverted
the documentation from the intermediate patch that you refer to:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=2305a5920fb8ee6ccec1c62ade05aa8351091d71

The cpuidle branch on git.kernel.org looks okay to me:

http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=shortlog;h=cpuidle

the top commit is this one:

commit 8975059a2c1e56cfe83d1bcf031bcf4cb39be743
Author: Adam Belay <abelay@novell.com>
Date:   Tue Aug 21 18:27:07 2007 -0400

    CPUIDLE: load ACPI properly when CPUIDLE is disabled

And this top patch is indeed included in the latest acpi test branch,
as well as the latest ACPI test patch here:

http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/test/2.6.23/acpi-test-20070126-2.6.23-rc5.diff.gz

Note that there were some merge conflicts when pulling cpuidle into 2.6.23,
so you are best off running either the acpi patch above on top of 2.6.23-rc5,
or the acpi test  branch, or the mm tree so you won't have to merge the
cpuidle branch onto your latest kernel again.

cheers,
-Len


