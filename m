Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbYEVVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbYEVVMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbYEVVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:12:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbYEVVMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:12:20 -0400
Date: Thu, 22 May 2008 16:40:48 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: another cpufreq pull request for .26
Message-ID: <20080522204048.GA16727@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ fixes

 Documentation/cpu-freq/governors.txt      |    8 --------
 arch/x86/kernel/cpu/cpufreq/longrun.c     |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 +++++++++++++--
 drivers/cpufreq/freq_table.c              |    5 +++++
 4 files changed, 19 insertions(+), 11 deletions(-)

commit 4f74369422b883164c50b5936517d010a3e1ce59
Author: Dominik Brodowski <linux@dominikbrodowski.net>
Date:   Thu May 22 08:52:05 2008 +0200

    [CPUFREQ] clarify license of freq_table.c
    
    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit da8395be0bb04f685d55f124d046766d9209214a
Author: Dave Jones <davej@redhat.com>
Date:   Tue May 20 22:13:09 2008 -0400

    [CPUFREQ] Remove documentation of removed ondemand tunable.
    
    sampling_down_factor was removed in ccb2fe209dac9ff67f6351e783e610073afaaeaf
    back in June 2006.
    
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 667ad4f70110357e8f024e81741c7bd1d7906e7d
Author: maximilian attems <max@stro.at>
Date:   Thu May 8 22:10:01 2008 +0200

    [CPUFREQ] Crusoe: longrun cpufreq module reports false min freq
    
    The longrun cpufreq module reports a false minimum frequency 3MHz on
    300-600MHz Crusoe processor.  This may be due to a calculation bug
    in the module.
    
    Original patch from Kaz Sasayama <kazssym@hypercore.co.jp>
    submitted as http://bugs.debian.org/468149 patch ported to x86
    
    Cc: Kaz Sasayama <kazssym@hypercore.co.jp>
    Signed-off-by: maximilian attems <max@stro.at>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit eba9fe93a2959ec7f195c47c9db6ce7b5114ce1f
Author: Mark Langsdorf <mark.langsdorf@amd.com>
Date:   Tue Mar 18 15:24:32 2008 -0500

    [CPUFREQ] powernow-k8: improve error messages
    
    The most common error with powernow-k8 is an ACPI _PSS error
    caused either by failure to load the ACPI processor module
    or a bad parse of the _PSS object.  Make the error message
    returned to the user in these situations more straightforward
    and easier to understand.
    
    -Mark Langsdorf
    Operating System Research Center
    AMD
    
    Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

-- 
http://www.codemonkey.org.uk
