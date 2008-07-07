Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbYGGJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbYGGJWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYGGJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 05:22:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYGGJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 05:21:59 -0400
To: nickpiggin@yahoo.com.au
CC: miklos@szeredi.hu, jamie@shareable.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, hugh@veritas.com
In-reply-to: <200807071638.32955.nickpiggin@yahoo.com.au> (message from Nick
	Piggin on Mon, 7 Jul 2008 16:38:31 +1000)
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
References: <20080625124038.103406301@szeredi.hu> <20080625173837.GA10005@shareable.org> <E1KBZqG-0008OZ-Pw@pomaz-ex.szeredi.hu> <200807071638.32955.nickpiggin@yahoo.com.au>
Message-Id: <E1KFmuc-0001VS-RS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Jul 2008 11:21:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Nick Piggin wrote:
> I don't know what became of this thread, but I agree with everyone else
> you should not skip clearing PG_uptodate here. If nothing else, it
> weakens some important assertions in the VM. But I agree that splice
> should really try harder to work with it and we should be a little
> careful about just changing things like this.

Sure, that's why I rfc'ed.

But I'd still like to know, what *are* those assumptions in the VM
that would be weakened by this?

Thanks,
Miklos
