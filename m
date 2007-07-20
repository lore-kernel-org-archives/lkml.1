Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbXGTKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbXGTKtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXGTKtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:49:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48793 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXGTKtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:49:16 -0400
Subject: Re: [PATCH 1/6] compacting file_ra_state
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1184927207.20032.168.camel@twins>
References: <20070720100740.106917381@mail.ustc.edu.cn>
	 <20070720101123.936159499@mail.ustc.edu.cn>
	 <1184927207.20032.168.camel@twins>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 12:48:59 +0200
Message-Id: <1184928539.20032.171.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 12:26 +0200, Peter Zijlstra wrote:
> On Fri, 2007-07-20 at 18:07 +0800, Fengguang Wu wrote:
> > plain text document attachment (short-rasize.patch)
> > Use 'unsigned int' instead of 'unsigned long' for the readahead indexes/sizes.
> > 
> > This helps reduce memory consumption on 64bit CPU when
> > a lot of files are opened.
> > 
> > Note that the (smaller) 32bit index can support up to 16PB file.
> > Which should be sufficient large at least for now.
> 
> Perhaps merge prev_offset and prev_index into a pgoff_t prev? That
> should give the same savings on 64bit and be more correct on 32bit.

s/pgoff_t/loff_t/

(and how come lkml was not on the CC list?)

