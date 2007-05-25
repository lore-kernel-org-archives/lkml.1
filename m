Return-Path: <linux-kernel-owner+w=401wt.eu-S1761892AbXEYOmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761892AbXEYOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 10:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXEYOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 10:42:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbXEYOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 10:42:38 -0400
Message-ID: <4656F5BD.40800@redhat.com>
Date: Fri, 25 May 2007 10:42:05 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       len.brown@intel.com
Subject: Re: [PATCH 2/2] msi:  Add support for the Intel chipsets that support
 MSI.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>	<m1r6p5cyut.fsf_-_@ebiederm.dsl.xmission.com>	<200705250738.57066.ak@suse.de> <m17iqxcu27.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17iqxcu27.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2007 02:10 AM, Eric W. Biederman wrote:
>>> This patch should be safe.  The anecdotal evidence is that when dealing
>>> with MSI the Intel chipsets just work.  If we find some buggy ones
>>> changing the list won't be hard.
>> The FADT bit should be probably checked anyways.
> 
> Sure if we have a way to check I have no problem, although I tend to
> trust the hardware more.
> 

Already in 2.6.22:

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f8993aff8b4de0317c6e081802ca5c86c449fef2
Commit:     f8993aff8b4de0317c6e081802ca5c86c449fef2
Parent:     a23cf14b161b8deeb0f701d577a0e8be6365e247
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Wed Apr 25 11:05:12 2007 +0800
Committer:  Len Brown <len.brown@intel.com>
CommitDate: Wed Apr 25 01:13:47 2007 -0400

    ACPI: Disable MSI on request of FADT
