Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbXEPPyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbXEPPyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbXEPPyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:54:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXEPPyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:54:25 -0400
Message-ID: <464B28F2.9050400@redhat.com>
Date: Wed, 16 May 2007 11:53:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bob Tracy <rct@gherkin.frus.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
References: <20070516131558.E15BFDBA1@gherkin.frus.com>
In-Reply-To: <20070516131558.E15BFDBA1@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy wrote:
> Jan Engelhardt wrote:
>>> On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
>>>
>>>> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.

> Intel machine check architecture supported.
> general protection fault: 0000 [#1]
> PREEMPT
> Modules linked in:
> CPU:   0
> EIP: 0060:[<c01079f4>]  Not tainted VLI
> EFLAGS: 00010286   (2.6.22-rc1 #1)
> EIP is at amd_mcheck_init+0x2b/0xc3
> 

rdmsr with ecx == 0x179 (Machine Check Global Capabilities Register)

Probably K6 doesn't have that.

Caused by:

	[PATCH] i386: check capability

