Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbXEKH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbXEKH6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXEKH6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:58:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:28329 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbXEKH6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PlGX6a7H5FJHVEJWelKeSO8IdS9m8vathuh5UrbvC42/tt2J/f4z5tXG8S3BXDKi4hP6VMlm2FxtU1TlDzi/Wa0bahWMl34pz3y6pgOQ3c8UP4+Nrdgc5JTh+bMXpA+/qeV/fWqG7f7R1FdZAUtn9VCrWqmyHlcOR8CmH7XeFJU=
Date: Fri, 11 May 2007 11:57:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511075759.GC9444@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511072939.GA25727@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Fri, May 11, 2007 at 08:29:39AM +0100]
[..snip..] 
| And please get rid of the UDF_I_* macro for everything you touch, just
| put a
| 
| 	struct udf_inode_info *uip = UDF_I(inode);
| 
| at the beginning of the function and use the fields directly.
| 

Christoph, I think there should be a separated patch to remove
UDF_I_* macro. I'll make it ;) 

Andrew, may be I should produce a series of patch:
	- 1st to check the memory
	- 2nd to get rid of UDF_I_* macro
?

		Cyrill

