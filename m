Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYHSTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYHSTof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYHSToY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:44:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbYHSToW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:44:22 -0400
Date: Tue, 19 Aug 2008 15:43:25 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Arnold, Frank" <Frank.Arnold@amd.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] Revert "[CPUFREQ][2/2] preregister support for
	powernow-k8"
Message-ID: <20080819194325.GA641@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Langsdorf, Mark" <mark.langsdorf@amd.com>,
	LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Arnold, Frank" <Frank.Arnold@amd.com>,
	Torsten Kaiser <just.for.lkml@googlemail.com>
References: <200808092321.16711.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com> <200808192137.55818.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808192137.55818.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 09:37:54PM +0200, Rafael J. Wysocki wrote:
 > From: Rafael J. Wysocki <rjw@sisk.pl>
 > 
 > Revert "[CPUFREQ][2/2] preregister support for powernow-k8"
 >     
 > Revert commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
 > ("[CPUFREQ][2/2] preregister support for powernow-k8") that causes
 > regressions tracked as:
 > http://bugzilla.kernel.org/show_bug.cgi?id=11296 ,
 > http://bugzilla.kernel.org/show_bug.cgi?id=11339 .
 > Namely, my test box with the Asus M3A32-MVP mainboard and the AMD
 > Phenom 9850 CPU crashes during hibernation, suspend to RAM and ACPI
 > power off, apparently due to a failing CPU hotplug notifier.  In
 > turn, on the Torsten Kaiser's test system only one CPU is correctly
 > handled by cpufreq.  These problems go away after reverting
 > 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0, but unfortunately they are
 > quite difficult to debug.
 > 
 > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACKed-by: Dave Jones <davej@redhat.com>

	Dave

-- 
http://www.codemonkey.org.uk
