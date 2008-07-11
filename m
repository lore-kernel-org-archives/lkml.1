Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYGKW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYGKW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGKW7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:59:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbYGKW7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:59:11 -0400
Date: Fri, 11 Jul 2008 15:58:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a const assignment in moxa_load_fw()
Message-Id: <20080711155844.efab6a96.akpm@linux-foundation.org>
In-Reply-To: <26525.1215816501@redhat.com>
References: <20080711122056.8b36c084.akpm@linux-foundation.org>
	<20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
	<20080708171029.08db0f4d@the-village.bc.nu>
	<26525.1215816501@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 23:48:21 +0100 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Appears to already be fixed in linux-next, perhaps by this:
> 
> Some of the maintainers have already pushed through the patches I've sent to
> you and them.
> 

No, that was a week-old tree - the warning was fixed independently.  As
they often are - everyone gets to watch them fly past so lots of people
are motivated to fix them, and are able to test their fixes.

linux-next would be a better tree against which to do this sort of
thing.  Doing that would avoid this wasted effort, plus linux-next has
lots of nice new warnings to keep us occupied.
