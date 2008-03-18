Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYCRLeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYCRLeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYCRLeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:34:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYCRLd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:33:59 -0400
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080317191945.122011759@szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 12:33:51 +0100
Message-Id: <1205840031.8514.346.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-17 at 20:19 +0100, Miklos Szeredi wrote:
> plain text document attachment (end_page_writeback_nobdi.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Fuse's writepage will need to clear page writeback separately from
> updating the per BDI counters.

This is because of the juggling with temporary pages, right?

Would be nice to have some comments in the code explaining this.

