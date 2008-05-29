Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYE2SVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYE2SVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYE2SVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:21:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55988 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYE2SVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:21:40 -0400
Date: Thu, 29 May 2008 19:20:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: hans-christoph.rohland@sap.com, leg@google.com, pbadari@us.ibm.com,
       harvey.harrison@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: support aio
In-Reply-To: <20080528165815.f4e4982c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805291912490.553@blonde.site>
References: <Pine.LNX.4.64.0805290007320.7969@blonde.site>
 <20080528165815.f4e4982c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Andrew Morton wrote:
> 
> hm.  This version:
> is neater but generates 21 bytes more code.  Stupid gcc.
> 
> I don't believe we needed to check for count == 0?  We'd just loop around
> N times doing nothing.

You're right, thanks, and that's hardly a path we need to optimize.
I was just blindly copying generic_file_aio_read, but they would
both benefit from your improvement.  If you don't mind, I'll send
you a replacement patch for shmem.c, and a patch for filemap.c.

Hugh
