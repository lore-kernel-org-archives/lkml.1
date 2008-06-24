Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYFXScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYFXScO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYFXSb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:31:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbYFXSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:31:56 -0400
Date: Tue, 24 Jun 2008 11:31:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
In-Reply-To: <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org>
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
 <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org> <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Miklos Szeredi wrote:
> 
> OK.  But currently we have an implementation that
> 
>  1) doesn't do any of this, unless readahead is disabled

Sure. But removing even the conceptual support? Not a good idea.

> And in addition, splice-in and splice-out can return a short count or
> even zero count if the filesystem invalidates the cached pages during
> the splicing (data became stale for example).  Are these the right
> semantics?  I'm not sure.

What does that really have with splice() and removing the features? Why 
don't you just fix that issue? 

		Linus
