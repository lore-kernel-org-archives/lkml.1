Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbXH3Q1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbXH3Q1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbXH3Q1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:27:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbXH3Q1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:27:16 -0400
Message-ID: <46D6EFDE.4020107@redhat.com>
Date: Thu, 30 Aug 2007 12:27:10 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<23252.1188396273@turing-police.cc.vt.edu>	<3909.1188409058@turing-police.cc.vt.edu> <20070829161545.9fde1a5c.akpm@linux-foundation.org>
In-Reply-To: <20070829161545.9fde1a5c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2007 07:15 PM, Andrew Morton wrote:
>>> The issue:  vdso and gettimeofday seem to be having a quarrel.
>> This is also open as a Fedora bug:
>> https://bugzilla.redhat.com/show_bug.cgi?id=262481
>>
> 
> So it's an interaction between the x86_64 vdso patches in Andi's tree and 
> newer glibc, and we don't know which one is getting it wrong yet?
> 
> If I ever get another -mm out the door (have been without electricity for
> several days) I'll drop the vdso changes until this is sorted out.
> -

Problem is present in stock 2.6.23-rc too. Still don't know whether it is
the new glibc code or the vdso that's causing it, though.
