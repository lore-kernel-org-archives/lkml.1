Return-Path: <linux-kernel-owner+w=401wt.eu-S967266AbXEHUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967266AbXEHUs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934370AbXEHUs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:48:57 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:42739 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934366AbXEHUs4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:48:56 -0400
Date: Tue, 8 May 2007 21:48:52 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: Lockup after logging out of X
Message-ID: <20070508204852.GA30610@deepthought>
References: <20070508195142.GA30030@deepthought> <16635.1178655711@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <16635.1178655711@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:21:51PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 08 May 2007 20:51:42 BST, Ken Moffat said:
> 
> >  After trying git-bisect, it tells me:
> > 0dbf7028c0c1f266c9631139450a1502d3cd457e is first bad commit
> > commit 0dbf7028c0c1f266c9631139450a1502d3cd457e
> > Author: Vivek Goyal <vgoyal@in.ibm.com>
> > Date:   Wed May 2 19:27:07 2007 +0200
> > 
> >     [PATCH] x86: __pa and __pa_symbol address space separation
[...]
> 
> I saw this same exact problem on my box back at 21-rc5-mm4, but didn't
> report it here because Christoph Hellwig thinks such things are off-topic (as
> I was seeing it with the NVidia driver).
> 
> http://marc.info/?l=linux-kernel&m=117579249300455&w=2
> http://www.nvnews.net/vbulletin/showthread.php?t=89444
> 
> Sorry to see you hit a problem with the exact same patch with a Radeon card
> a month later.
> 
 OK, in view of the minimal oops output that made it to my log
(forgot to say in today's repost that it was from one of the bad
bisect builds), I'd better point out that I don't have the ati
module (fglrx or whatever it is called), this is purely using Linus'
tree.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
