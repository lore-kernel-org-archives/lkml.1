Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXEQXiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXEQXiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXEQXiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:38:18 -0400
Received: from gherkin.frus.com ([192.158.254.49]:51833 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXEQXiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:38:18 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <200705171435.31010.ak@suse.de> "from Andi Kleen at May 17, 2007
 02:35:30 pm"
To: Andi Kleen <ak@suse.de>
Date: Thu, 17 May 2007 18:38:13 -0500 (CDT)
CC: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Joachim Deguara <joachim.deguara@amd.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070517233813.266B6DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hmpf.
> 
> We cold either use rdmsr_safe or add a family check again or clear it 
> in k6 setup.  I think clearing it in setup is cleanest.
> 
> Does this patch work?
> 
> -Andi
> 
> Clear MCE flag on AMD K6
> 
> It reports machine check capability in CPUID, but doesn't actually
> implement all the necessary MSRs of the standard Intel machine
> check architecture.
> 
> This fixes a boot failure recently introduced.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>

ACK.  I reinstalled Joachim's patch (default 2.6.22-rc1 state), and
added your patch.  Life is good: we have a fix/workaround.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
