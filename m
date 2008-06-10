Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYFJMfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYFJMfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYFJMfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:35:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbYFJMfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:35:10 -0400
Date: Tue, 10 Jun 2008 08:34:27 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.26-rc5-mm2
Message-ID: <20080610083427.4262d0ab@bree.surriel.com>
In-Reply-To: <20080610021519.52af66f5.akpm@linux-foundation.org>
References: <20080609223145.5c9a2878.akpm@linux-foundation.org>
	<200806101728.27486.nickpiggin@yahoo.com.au>
	<20080610013427.aa20a29b.akpm@linux-foundation.org>
	<200806101848.22237.nickpiggin@yahoo.com.au>
	<20080610021519.52af66f5.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 02:15:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> We need to convince ourselves that these changes are the right way to
> fix <whatever they fix>.  We need to review and test the crap out of
> them.  The 64-bit-only thing is a concern.  I wonder about whether
> we've "fixed" anon pages but didn't do anything about file-backed
> mapped pages.

Quite possible.  The reclaim policy for file-backed pages has not
changed.  We don't know yet whether we'll have to change that, too.

-- 
All rights reversed.
