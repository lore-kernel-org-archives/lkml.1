Return-Path: <linux-kernel-owner+w=401wt.eu-S1422720AbXD3BQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422720AbXD3BQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 21:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422722AbXD3BQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 21:16:02 -0400
Received: from smtp-out.google.com ([216.239.45.13]:11358 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422720AbXD3BQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 21:16:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=o53ZxtdDyXW/Mcmb89QYHVG7eR8/byqf9KFIx8Mcp4bYzW7Yb4qKFd3MnNFXVjp42
	FHW9NQRaHjIe3dIvbGf9Q==
Message-ID: <4635433C.7030607@google.com>
Date: Sun, 29 Apr 2007 18:15:40 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ethan Solomita <solo@google.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: NR_UNSTABLE_FS vs. NR_FILE_DIRTY: double counting pages?
References: <4632A1A6.90702@google.com> <1177878135.6400.37.camel@heimdal.trondhjem.org> <463537C2.5050804@google.com>
In-Reply-To: <463537C2.5050804@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan Solomita wrote:
> Trond Myklebust wrote:
>>
>> It should not happen. If the page is on the unstable list, then it will
>> be committed before nfs_updatepage is allowed to redirty it. See the
>> recent fixes in 2.6.21-rc7.
> 
>     Above I present a codepath called straight from sys_write() which 
> seems to do what I say. I could be wrong, but can you address the code 
> paths I show above which seem to set both?

	Sorry about my quick reply, I'd misunderstood what you were saying. 
I'll take a look at what you say.

	Thanks,
	-- Ethan
