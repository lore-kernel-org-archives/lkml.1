Return-Path: <linux-kernel-owner+w=401wt.eu-S934707AbXJSWrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbXJSWrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXJSWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:46:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58579 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbXJSWq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:46:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710172348.23113.borntraeger@de.ibm.com>
	<m1myuhcrfu.fsf@ebiederm.dsl.xmission.com>
	<200710181126.10559.borntraeger@de.ibm.com>
Date: Fri, 19 Oct 2007 16:46:04 -0600
In-Reply-To: <200710181126.10559.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Thu, 18 Oct 2007 11:26:10 +0200")
Message-ID: <m1sl46en9v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Am Donnerstag, 18. Oktober 2007 schrieb Eric W. Biederman:
>> Grr. Inconsistent rules on a core piece of infrastructure.
>> It looks like that if there is any trivial/minimal fix it
>> is based on your patch suppressing try_to_free_buffers.  Ugh.
>> 
>> Eric
>
> Ok. What do you think about having my patch for 2.6.23 stable, for 2.6.24
> and doing a nicer fix (rd rewrite for example for post 2.6.24)?

Looking at it.  If we don't get carried away using our own private
inode is barely more difficult then stomping on release_page and
in a number of ways a whole lot more subtle.  At least for 2.6.24 I
think it makes a sane fix, and quite possibly as a back port as well.

Eric
