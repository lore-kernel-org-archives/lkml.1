Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYAYNma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYAYNma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYAYNmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:42:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:14498 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbYAYNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:42:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PMLKUsVwH7yQH0KC07bW4QL5jy1SQZjO8fQdJ8OD3ghQ3zp80aUPqSRoiVyrSQZrUhcaDoUw99gZ6E8C3kmR1FpWUjzBieimzeRjukKSDw0gx+AkOHpCFP3vXxiHcUlCODDf5EPhAtYq0s7bxe8qJ1mcbcynhuRo+NSaP+dZFJA=
Date: Fri, 25 Jan 2008 16:41:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: [patch 25/26] mount options: fix udf
Message-ID: <20080125134158.GA7233@cvg>
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg> <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Miklos Szeredi - Fri, Jan 25, 2008 at 10:29:21AM +0100]
| > | +	/* is this correct? */
| > | +	if (sbi->s_anchor[2] != 0)
| > | +		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
| > 
| > you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
| > in sake of style unification but we should wait for Jan's
| > decision (i'm not the expert in this area ;)
| 
| I think UDF_SB_ANCHOR macro was removed by some patch in -mm.
| 
| I'm more interested if the second element of the s_anchor array really
| does always have the value of the 'anchor=N' mount option.  I haven't
| been able to verify that fully.  Do you have some insight into that?
| 
| Thanks,
| Miklos
| 

Hello Miklos,

well, actually - no. anchor entities can be set to 0 if we have been failed
to read them in udf_find_anchor(). So it seems you've to use some
additional flag to store it.

Btw, Miklos the patch is over -mm tree?

		- Cyrill -
