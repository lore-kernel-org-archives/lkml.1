Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbYJMOZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbYJMOZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYJMOZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:25:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbYJMOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:25:31 -0400
Message-ID: <48F3765A.2010301@linux-foundation.org>
Date: Mon, 13 Oct 2008 09:24:58 -0700
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> I think it's wrong to unhash dentries while they are possibly still
> being used.  You can do the shrink_dcache_parent() here, but should
> leave the unhashing to be done by prune_one_dentry(), after it's been
> checked that there are no other users of the dentry.
>
>   
d_invalidate() calls shrink_dcache_parent() as needed and will fail if 
there are other users of the dentry.


