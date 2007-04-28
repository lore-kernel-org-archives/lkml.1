Return-Path: <linux-kernel-owner+w=401wt.eu-S1161458AbXD1P2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161458AbXD1P2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161459AbXD1P2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:28:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59911 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161458AbXD1P2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:28:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
References: <4632AE54.7030200@goop.org>
	<m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
	<200704281229.48597.ak@suse.de> <46335A26.4020109@goop.org>
Date: Sat, 28 Apr 2007 09:27:37 -0600
In-Reply-To: <46335A26.4020109@goop.org> (Jeremy Fitzhardinge's message of
	"Sat, 28 Apr 2007 07:28:54 -0700")
Message-ID: <m1bqh8friu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Andi Kleen wrote:
>>> My preference would be for whoever had:
>>> paravirt_ops-hooks-to-set-up-initial-pagetable.patch
>>>     
>>
>> That would be very messy because there are many followup dependencies.
>>
>> But once we have a good fix aggreed by everybody I can merge it into the 
>> initial patch then.
>
> I'm working on an incremental fix.

Except for Xen my patch should work incrementally.

Just so long as we don't push this change upstream until we fix
this, we should be ok.

Eric
