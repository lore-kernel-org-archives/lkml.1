Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0BKKJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:09:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:62055 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0BKKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZE9quNpVFD4JdMfI21ajNjPXngBastSC88pjwcKFC1n5YCoqyw30PWp2xZRKM9CM3l
         ZACGafzyoyDsAzuvyTXLNImwVpNQpINU3EJzyIrOr9HmneDQSe3u6eSUGyCV9/1luDcn
         AkMatmkCNYgU+wcKxqUzu/I/n/1nmtBgpsfAk=
Date: Thu, 11 Feb 2010 11:10:13 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Alexander Lam <lambchop468@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mtrr cleanup not doing anything on 2.6.33-rc7
Message-ID: <20100211101013.GA4892@Pilar.aei.mpg.de>
References: <dfb03c971002101202i37f4a243jc6bfb44bc853cb5d@mail.gmail.com>
 <dfb03c971002101748i39d7de0bw83634c40f058de0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb03c971002101748i39d7de0bw83634c40f058de0f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Add people in that commit to Cc: list, just in case]

On Mi 10.Feb'10 at 20:48:49 -0500, Alexander Lam wrote:
> On Wed, Feb 10, 2010 at 3:02 PM, Alexander Lam <lambchop468@gmail.com> wrote:
> >
> > My kernel config has the following:
> > CONFIG_MTRR=y
> > CONFIG_MTRR_SANITIZER=y
> > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> >
> > With previous kernels, dmesg would show that the sanitizer was indeed
> > cleaning up the mtrrs [1]
> >
> > but now, with 2.6.33-rc7 there is no indication that this is occuring,
> 
> For those who run across this later,
> 
> Found out that commit 508d85c2c6bc8cba53d2a54d9a306ad64a0a80bf,
>    x86: When cleaning MTRRs, do not fold WP into UC
> 
> causes mtrr cleanup not to run on my machine.
> 
> Probably not worth fixing because the i915 error message is harmless.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
