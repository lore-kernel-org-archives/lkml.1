Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXLSQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXLSQcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbXLSQb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:31:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33937 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXLSQb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:31:58 -0500
Date: Wed, 19 Dec 2007 11:31:07 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
Subject: Re: [patch 02/20] make the inode i_mmap_lock a reader/writer lock
Message-ID: <20071219113107.5301f9f0@cuia.boston.redhat.com>
In-Reply-To: <1198079529.5333.12.camel@localhost>
References: <20071218211539.250334036@redhat.com>
	<20071218211548.784184591@redhat.com>
	<200712191148.06506.nickpiggin@yahoo.com.au>
	<1198079529.5333.12.camel@localhost>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 10:52:09 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> I keep these patches up to date for testing.  I don't have conclusive
> evidence whether they alleviate or exacerbate the problem nor by how
> much.  

When the queued locking from Ingo's x86 tree hits mainline,
I suspect that spinlocks may end up behaving a lot nicer.

Should I drop the rwlock patches from my tree for now and
focus on just the page reclaim stuff?

-- 
All Rights Reversed
