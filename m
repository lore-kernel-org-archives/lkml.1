Return-Path: <linux-kernel-owner+w=401wt.eu-S932428AbYCGMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbYCGMg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbYCGMgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:36:47 -0500
Received: from gherkin.frus.com ([192.158.254.49]:39956 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbYCGMgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:36:46 -0500
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
In-Reply-To: <20080307072304.GA25351@elte.hu> "from Ingo Molnar at Mar 7, 2008
 08:23:05 am"
To: Ingo Molnar <mingo@elte.hu>
Date: Fri, 7 Mar 2008 06:36:44 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080307123645.0CB5BDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Bob, does latest -git boot if you revert these 4 commits:

(FUJITA Tomonori's Alpha IOMMU changes)

I'll get things set up to try that later today...  In the meantime, it
appears the regression is relative to -rc3: I'm up and running on that
kernel as I type this.

> * Bob Tracy <rct@frus.com> wrote:
> 
> > (panic with 2.6.24-rc4 on Alpha)
> > The panic is completely reproducible.  The "Code" line at the bottom
> > of the panic output is
> > 
> > 44220001 4821f621 4821b681 4821f62b f420004f 00000081 <0000009b> 0066c012
> > 
> > The first line of the "Trace" section is
> > 
> >  [<fffffc000031a41f>] iommu_arena_alloc+0x64/0xe0
> > 

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
