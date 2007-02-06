Return-Path: <linux-kernel-owner+w=401wt.eu-S1751063AbXBFKVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbXBFKVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXBFKVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:21:49 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58095 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXBFKVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:21:48 -0500
Message-ID: <45C856B9.8020207@in.ibm.com>
Date: Tue, 06 Feb 2007 15:51:45 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060918)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jkenisto@us.ibm.com, anil.s.keshavamurthy@intel.com,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
References: <45C85097.1000106@in.ibm.com> <20070206021300.698ecb2c.akpm@linux-foundation.org>
In-Reply-To: <20070206021300.698ecb2c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 Feb 2007 15:25:35 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
>>         I have developed a patch, that lists all active probes in the
>> system.
> 
> userspace added the probes, so userspace should know where they all are?
Irrespective of the number of users/modules that use kprobes, this is
one place where you can get all the info.
