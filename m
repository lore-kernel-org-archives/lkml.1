Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYFJVPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYFJVPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbYFJVOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:14:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbYFJVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:14:54 -0400
Date: Tue, 10 Jun 2008 17:14:00 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 17/25] Mlocked Pages are non-reclaimable
Message-ID: <20080610171400.149886cf@cuia.bos.redhat.com>
In-Reply-To: <20080610033130.GK19404@wotan.suse.de>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.522708682@redhat.com>
	<20080606180746.6c2b5288.akpm@linux-foundation.org>
	<20080610033130.GK19404@wotan.suse.de>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 05:31:30 +0200
Nick Piggin <npiggin@suse.de> wrote:

> If we eventually run out of page flags on 32 bit, then sure this might be
> one we could look at geting rid of. Once the code has proven itself.

Yes, after the code has proven stable, we can probably get
rid of the PG_mlocked bit and use only PG_unevictable to mark
these pages.

Lee, Kosaki-san, do you see any problem with that approach?
Is the PG_mlocked bit really necessary for non-debugging
purposes?

-- 
All Rights Reversed
