Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbXEKJCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbXEKJCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbXEKJCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:02:09 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:15109 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbXEKJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KAVMRTdjoqA6kKkYBuccTtYqi5heyVnZzIo8PQ5k5RECTODz8xOciwnnZhAFVRJzLeuU+kvjK9AcrfZZ1t/vlbUD82eNcv3Vu5RIiIsnxAqcY9b0pHvuQuSx2lboj4npL72qVAqlK4jCuV/4dHNIXHkyCGPExlRL6aiSdzlKef0=
Date: Fri, 11 May 2007 13:01:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511090127.GD9444@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511072939.GA25727@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Fri, May 11, 2007 at 08:29:39AM +0100]

...

| And please get rid of the UDF_I_* macro for everything you touch, just
| put a
| 
| 	struct udf_inode_info *uip = UDF_I(inode);
| 
| at the beginning of the function and use the fields directly.
| 

Actually to properly remove UDF_I* and UDF_SB_* macroses in the
whole UDF subsystem - is _lot_ of work. I'm going to make it but
not now (too busy).

		Cyrill

