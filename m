Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXJPH5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXJPH5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765473AbXJPH5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:57:12 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:47975 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765461AbXJPH5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:57:10 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
Date: Tue, 16 Oct 2007 09:56:57 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <m14pgsknmd.fsf_-_@ebiederm.dsl.xmission.com> <m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710160956.58061.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 16. Oktober 2007 schrieb Eric W. Biederman:

> fs/buffer.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
>  drivers/block/rd.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)

Your patches look sane so far. I have applied both patches, and the problem 
seems gone. I will try to get these patches to our testers.

As long as they dont find new problems:

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Nick, Eric. What is the best patch for the stable series? Both patches from
Eric or mine? I CCed stable, so they know that something is coming.

Christian
