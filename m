Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbXEQMzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbXEQMzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXEQMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:55:00 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33858 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbXEQMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:54:59 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <200705171435.31010.ak@suse.de> "from Andi Kleen at May 17, 2007
 02:35:30 pm"
To: Andi Kleen <ak@suse.de>
Date: Thu, 17 May 2007 07:54:54 -0500 (CDT)
CC: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Joachim Deguara <joachim.deguara@amd.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070517125454.01641DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Clear MCE flag on AMD K6
> 
> It reports machine check capability in CPUID, but doesn't actually
> implement all the necessary MSRs of the standard Intel machine
> check architecture.
> 
> This fixes a boot failure recently introduced.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

I want to acknowledge receiving the above, but it arrived too late for
me to test this morning (the work day intrudes).  I'll get a new kernel
built, test this, and report back in about 10-11 hours.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
