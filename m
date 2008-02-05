Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYBEO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYBEO6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYBEO60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:58:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:65517 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYBEO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EpIRIuqMhT/EisPbJvN8acnSHHFF8WHk3RmHhq2pcLy9RWlM44Tt3SKcffQn1/Is5xjMTwGIjBwaG2Kcj1c5P6cZ1frXs5aKvOwohK0CuGA/zfOon34dYWVcYJr4xa8ghrgHPdHFAaSEtlHDNlTnkOg3rIA5CSExe+0S8RVJsmk=
Message-ID: <524f69650802050658j4683c2aewefdc957f3b8b1d09@mail.gmail.com>
Date: Tue, 5 Feb 2008 08:58:22 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove smbfs
Cc: "Jeff Layton" <jlayton@redhat.com>, "Guenter Kukkukk" <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       "Adrian Bunk" <bunk@kernel.org>, sfrench@samba.org
In-Reply-To: <20080205001805.0ea014f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <200801302216.13788.linux@kukkukk.com>
	 <20080130174103.17ff8197@tleilax.poochiereds.net>
	 <20080205001805.0ea014f3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 2:18 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 30 Jan 2008 17:41:03 -0500 Jeff Layton <jlayton@redhat.com> wrote:
>
> > I have no problem with targeting smbfs for removal, but I thought
> > Andrew had an unofficial policy that we should first mark things to be
> > deprecated, and then remove them 2 releases later. That seems like a
> > sensible policy to me. If we mark it deprecated in 2.6.25 then we can
> > remove it after 2.6.26 is released.
> >
> > It might not even hurt to have a nice loud printk when the smbfs
> > module is plugged in to warn users that it's slated to be removed,
> > and that they should move to CIFS as soon as possible.

> From: Andrew Morton <akpm@linux-foundation.org>
>
> smbfs is a bit buggy and has no maintainer.  Change it to shout at the user on
> the first five mount attempts - tell them to switch to CIFS.
>
> Come December we'll mark it BROKEN and see what happens.
>

> +       if (warn_count < 5) {
> +               warn_count++;
> +               printk(KERN_EMERG "smbfs is deprecated and will be removed in"
> +                               " December, 2006.  Please migrate to cifs\n");
> +       }
>
>         if (!raw_data)
>                 goto out_no_data;
> _
>
>
> queued for over 1.5 years waiting for the go-ahead from Steve.
>
> It looks like it's time?  If so, what should I set the date to?

If the 2.6.26 cycle would starts in April, then saying April 2008 is
fine with me.



-- 
Thanks,

Steve
