Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXFSU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXFSU6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXFSU6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:58:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:11964 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXFSU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BnYmUZs/mhJgNBrkGsC31WSPoViu2NNSETbxOcae+D0DvGC1VjNauzkGvrHaGr74O2/vgXRXc6c/XjLOa4J+B/oNmLjyIX13kjME3wr5ILs7ruVsw74uBJM4fLRFffF7uzMSmwOfFTkRQ9otcIrbFBdfUX1yE7kI7xVeeREtMhQ=
Message-ID: <84144f020706191358j1992dd50ga5d93efbd61878d6@mail.gmail.com>
Date: Tue, 19 Jun 2007 23:58:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 11/26] SLUB: Add support for kmem_cache_ops
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095916.083793990@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095916.083793990@sgi.com>
X-Google-Sender-Auth: 821c8b5d99c6af2f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> We use the parameter formerly used by the destructor to pass an optional
> pointer to a kmem_cache_ops structure to kmem_cache_create.
>
> kmem_cache_ops is created as empty. Later patches populate kmem_cache_ops.

I like kmem_cache_ops but I don't like this patch. I know its painful
but we really want the introduction patch to fixup the API (move ctor
to kmem_cache_ops and do the callers).
