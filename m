Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbXJRJ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbXJRJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbXJRJ0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:26:15 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7164 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXJRJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:26:14 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
Date: Thu, 18 Oct 2007 11:26:10 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710172348.23113.borntraeger@de.ibm.com> <m1myuhcrfu.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1myuhcrfu.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181126.10559.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. Oktober 2007 schrieb Eric W. Biederman:
> Grr. Inconsistent rules on a core piece of infrastructure.
> It looks like that if there is any trivial/minimal fix it
> is based on your patch suppressing try_to_free_buffers.  Ugh.
> 
> Eric

Ok. What do you think about having my patch for 2.6.23 stable, for 2.6.24
and doing a nicer fix (rd rewrite for example for post 2.6.24)?

Christian
