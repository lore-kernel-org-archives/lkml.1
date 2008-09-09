Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYIIMFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYIIMFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbYIIMFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:05:06 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34423 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYIIMFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:05:05 -0400
Date: Tue, 9 Sep 2008 13:04:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ifdef Quicklists in /proc/meminfo
In-Reply-To: <48C5BBEC.5060405@zytor.com>
Message-ID: <Pine.LNX.4.64.0809091246210.25571@blonde.site>
References: <Pine.LNX.4.64.0809081351240.4983@blonde.site>
 <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48C5BBEC.5060405@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> 
> x86 *does* use quicklists, at least with PAE.

Are you harking back to the good old days of 2.6.24?
Or looking ahead to a bright new future?

There was a defect, in the TLB flushing sequence IIRC,
which got them kicked out in a hurry.  They might return
- but I think everybody would prefer to have a better way
of applying the existing allocators than this extra pool.

Hugh
