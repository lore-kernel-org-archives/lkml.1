Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbXKCR4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbXKCR4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbXKCR4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:56:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33910 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbXKCR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:56:41 -0400
Date: Sat, 3 Nov 2007 17:55:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Willy Tarreau <w@1wt.eu>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-stable@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <20071103173807.GB1045@1wt.eu>
Message-ID: <Pine.LNX.4.64.0711031750420.11221@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <20071103173807.GB1045@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Willy Tarreau wrote:
> On Sat, Nov 03, 2007 at 05:10:54PM +0000, Hugh Dickins wrote:
> > I recommend this for 2.6.24-rc2 and 2.6.23-stable.
> 
> Hugh, you should also have CC'd linux-stable for this, otherwise there's
> a risk that the patch remains unnoticed by the stable team (CC'd).

That was intentional, actually: I thought Christoph ought to have
a say in it first.  Then he or I would alert the stable team.

And it turns out, see other mail, that the patches wouldn't even
apply as is to -stable: let's forget 2/2 so far as -stable goes,
and I'll now look into versions of 1/2 for 2.6.23 and 2.6.22
(checking whether the problem really happens there or not).

Hugh
