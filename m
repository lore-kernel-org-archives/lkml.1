Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYCRL70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYCRL70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYCRL7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:59:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47956 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYCRL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:59:16 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1205840031.8514.346.camel@twins> (message from Peter Zijlstra on
	Tue, 18 Mar 2008 12:33:51 +0100)
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu> <1205840031.8514.346.camel@twins>
Message-Id: <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 12:59:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-03-17 at 20:19 +0100, Miklos Szeredi wrote:
> > plain text document attachment (end_page_writeback_nobdi.patch)
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Fuse's writepage will need to clear page writeback separately from
> > updating the per BDI counters.
> 
> This is because of the juggling with temporary pages, right?
> 
> Would be nice to have some comments in the code explaining this.

Yup, well it will go through a bigger cleanup, as discussed with
Andrew, if that's OK with you?

Miklos
