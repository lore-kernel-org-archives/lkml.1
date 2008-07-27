Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYG0Nl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYG0Nl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYG0NlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:41:21 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55760 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYG0NlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:41:21 -0400
Date: Sun, 27 Jul 2008 14:40:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
In-Reply-To: <20080727130410.GI9301@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0807271437330.32444@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
 <20080726173832.GE9301@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0807261852050.582@blonde.site>
 <20080726125025.465d524b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0807262104060.13201@blonde.site> <20080726132610.6c583346.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0807262132460.15972@blonde.site> <20080726204218.GG9301@cs181140183.pp.htv.fi>
 <Pine.LNX.4.64.0807262155160.17736@blonde.site> <20080727130410.GI9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Adrian Bunk wrote:
> On Sat, Jul 26, 2008 at 10:05:34PM +0100, Hugh Dickins wrote:
> > 
> > It was this one, just including pagemap.h back in exec.c again:
> > not the best solution, but should be good for now.  Please would
> > you give it the build testing you were giving yours?  Or feel free
> > to point out that I'm wasting your and everybody's time, and just
> > call for a straight revert of ba92a43d, that'd be fine too.
> 
> No problems found, patch works fine.

Thanks a lot, Adrian: signed-off version follows with updated subject.

Hugh
