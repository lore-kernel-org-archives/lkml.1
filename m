Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXJQWXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXJQWXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXJQWW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:22:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38385 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXJQWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:22:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710171814.01717.borntraeger@de.ibm.com>
	<m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
	<200710172348.23113.borntraeger@de.ibm.com>
Date: Wed, 17 Oct 2007 16:22:13 -0600
In-Reply-To: <200710172348.23113.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Wed, 17 Oct 2007 23:48:23 +0200")
Message-ID: <m1myuhcrfu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Am Mittwoch, 17. Oktober 2007 schrieb Eric W. Biederman:
>> Did you have both of my changes applied?
>> To init_page_buffer() and to the ramdisk_set_dirty_page?
>
> Yes, I removed my patch and applied both patches from you. 

Thanks.

Grr. Inconsistent rules on a core piece of infrastructure.
It looks like that if there is any trivial/minimal fix it
is based on your patch suppressing try_to_free_buffers.  Ugh.

Eric
