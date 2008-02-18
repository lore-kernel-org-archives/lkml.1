Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYBRSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYBRSex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 13:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYBRSeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 13:34:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46388 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYBRSep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 13:34:45 -0500
Date: Mon, 18 Feb 2008 10:33:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Adrian Bunk <bunk@kernel.org>, Roel Kluin <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080218103320.41cf096f@laptopd505.fenrus.org>
In-Reply-To: <26571.1203358266@turing-police.cc.vt.edu>
References: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
	<47B70A61.9030306@tiscali.nl>
	<20080216092552.325e5726@laptopd505.fenrus.org>
	<20080216173315.GU8953@1wt.eu>
	<20080216094226.1e8eede1@laptopd505.fenrus.org>
	<47B72BFE.9060302@am.sony.com>
	<20080216103927.2a02352b@laptopd505.fenrus.org>
	<1203249003.6718.24.camel@concordia>
	<20080218135609.GD21080@cs181133002.pp.htv.fi>
	<12131.1203344830@redhat.com>
	<26571.1203358266@turing-police.cc.vt.edu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 13:11:06 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Mon, 18 Feb 2008 14:27:10 GMT, David Howells said:
> 
> > __builtin_expect() is useful on FRV where you _have_ to give each
> > branch and conditional branch instruction a measure of probability
> > whether the branch will be taken.
> 
> What does gcc do the 99.998% of the time we don't have
> likely/unlikely coded?

see Andi's email.
It gets the exact same hints that 95%+ of the kernels unlikely/likely get you,
because the heuristics in it are usually the same as the kernel programmers 
heuristics.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
