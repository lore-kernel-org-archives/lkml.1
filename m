Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZCLFp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZCLFp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZCLFps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:45:48 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:63726 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbZCLFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:45:47 -0400
From: Frans Pop <elendil@planet.nl>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of is_linear_pfn_mapping
Date: Thu, 12 Mar 2009 06:45:42 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, thellstrom@vmware.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>, ebiederm@xmission.com
References: <498B5ADE.3090602@vmware.com> <200903112309.40145.elendil@planet.nl> <1236817912.4529.76.camel@localhost.localdomain>
In-Reply-To: <1236817912.4529.76.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120645.44515.elendil@planet.nl>
X-OriginalArrivalTime: 12 Mar 2009 05:45:45.0000 (UTC) FILETIME=[C98D8A80:01C9A2D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Pallipadi, Venkatesh wrote:
> Thanks for testing this. I don't seem to reproduce this on any of my
> test systems with this patch on either tip or latest git. Do you see
> the hang on every boot or once in a while? 

The problem only occurs after some time. In the case shown in the log the 
system ran fine for 15 minutes and then triggered the oops.

In another case I was running VirtualBox. It ran fine for some time but 
the system hung when I tried to close the guest system.

> Are things stable with nopat?

Yes. Seen no problems since booting with 'nopat' and done a successful 
suspend/resume. With 'pat' I saw the problem 3 times after a short period 
of use.

On Thursday 12 March 2009, you wrote:
> Thinking about it a bit more, the usage of VM_NONLINEAR flag in
> this patch may be conflicting with some expectation in
> mm code, that may be resulting in above oops. Let me
> spend some more time on this and get back to you.

Thanks.
