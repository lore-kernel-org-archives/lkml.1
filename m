Return-Path: <linux-kernel-owner+w=401wt.eu-S1946378AbXD3QnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946378AbXD3QnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946380AbXD3QnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:43:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41753 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946378AbXD3QnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:43:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 08/12] i386: Convert the boot time page tables to the kernels native format.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
	<200704301826.57920.ak@suse.de>
Date: Mon, 30 Apr 2007 10:42:31 -0600
In-Reply-To: <200704301826.57920.ak@suse.de> (Andi Kleen's message of "Mon, 30
	Apr 2007 18:26:57 +0200")
Message-ID: <m1odl53jbc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Monday 30 April 2007 18:15:08 Eric W. Biederman wrote:
>> 
>> Currently we have a lot of special case code and a lot of limitations
>> because we cannot count on the initial boot time page tables being in
>> the format our page table handling routines know how to manipulate.
>> So this patch rewrites the code that initializes our boot time page
>> tables.
>
> Sounds reasonable, but for post .22

Sure.  A little aging to gain confidence with it is reasonable.  At
this point I finally have the glitches worked out so these patches
needed to get out of my private queue.

Eric
