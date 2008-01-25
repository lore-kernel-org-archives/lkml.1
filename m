Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYAYK5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYAYK5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYAYK5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:57:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:4785 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYAYK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oiS8y/lUwxEJFumbr9nTwa6lBj3DLm7iNNc0IC7wp5cw7NYbMb5UwCF09KGWK6yhgjO+AaPxEhcgTBIm1ehVLRXz/5jz7suAZcWI1ZrYxRYWTfSfElkPcgsh1k9tHiHpe64RmFdGk8TRqne1pridfLprzryUbDmob7AVBiJ4Fv4=
Message-ID: <aa79d98a0801250257y578de3dekec6b8589217dd7f4@mail.gmail.com>
Date: Fri, 25 Jan 2008 13:57:23 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [patch 25/26] mount options: fix udf
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jack@suse.cz
In-Reply-To: <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080124193341.166753833@szeredi.hu>
	 <20080124193456.220272889@szeredi.hu> <20080124202034.GC6724@cvg>
	 <E1JIKsD-0001Kf-Bz@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 12:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > | +   /* is this correct? */
> > | +   if (sbi->s_anchor[2] != 0)
> > | +           seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
> >
> > you know, I would prefer to use form UDF_SB_ANCHOR(sb)[2]
> > in sake of style unification but we should wait for Jan's
> > decision (i'm not the expert in this area ;)
>
> I think UDF_SB_ANCHOR macro was removed by some patch in -mm.
>
> I'm more interested if the second element of the s_anchor array really
> does always have the value of the 'anchor=N' mount option.  I haven't
> been able to verify that fully.  Do you have some insight into that?
>
> Thanks,
> Miklos
>

Miklos,

I'll check this today evening (a bit busy now).

- Cyrill -
