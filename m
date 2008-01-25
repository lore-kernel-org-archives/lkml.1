Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbYAYJ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbYAYJ3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbYAYJ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:29:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44837 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034AbYAYJ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:29:26 -0500
To: gorcunov@gmail.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jack@suse.cz
In-reply-to: <20080124202034.GC6724@cvg> (message from Cyrill Gorcunov on Thu,
	24 Jan 2008 23:20:34 +0300)
Subject: Re: [patch 25/26] mount options: fix udf
References: <20080124193341.166753833@szeredi.hu> <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg>
Message-Id: <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 10:29:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | +	/* is this correct? */
> | +	if (sbi->s_anchor[2] != 0)
> | +		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
> 
> you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
> in sake of style unification but we should wait for Jan's
> decision (i'm not the expert in this area ;)

I think UDF_SB_ANCHOR macro was removed by some patch in -mm.

I'm more interested if the second element of the s_anchor array really
does always have the value of the 'anchor=N' mount option.  I haven't
been able to verify that fully.  Do you have some insight into that?

Thanks,
Miklos
