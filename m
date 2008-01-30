Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbYA3R1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbYA3R1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbYA3R1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:27:41 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:21577 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbYA3R1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hs+zNYfs7+95LQaL0xzp6GOinJYEigYc+Cx/ZH/qK6z66bNFsnifCIEsOnmfs2OOudvBIFVRyrGKlfA0dJZ/gRv726OEkUY55FV9pnzWzavL+tTkGa7+bi8uiFOy0AWY9n0itlEuh42jgvGFW49chZu+rSAH7mtdkEGGalEpBoM=
Message-ID: <386072610801300927u5fa3786bn5e6ff0c4deef9ff5@mail.gmail.com>
Date: Thu, 31 Jan 2008 01:27:36 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: [PATCH 1/1] [Kallsyms] Blackfin: Allow kernel symbols in L1 to be found
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-kernel@vger.kernel.org,
       "Robin Getz" <robin.getz@analog.com>
In-Reply-To: <47A05CBA.2030903@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201688453-1763-1-git-send-email-bryan.wu@analog.com>
	 <47A05CBA.2030903@grupopie.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 7:17 PM, Paulo Marques <pmarques@grupopie.com> wrote:
> Bryan Wu wrote:
> > From: Robin Getz <robin.getz@analog.com>
> > [...]
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -12,6 +12,8 @@
> >   * (25/Aug/2004) Paulo Marques <pmarques@grupopie.com>
> >   *      Changed the compression method from stem compression to "table lookup"
> >   *      compression
> > + * (10/Jul/2006) Robin Getz <rgetz@blackfin.uclinux.org>
> > + *      Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.
>
> When I wrote this initially, it was a mistake to add a Changelog in the
> first place, but I didn't know better at the time.
>
> If you're going to make changes to this file, please remove all the
> Changelog, instead of adding more entries to it. The "Changelog" should
> be kept by the version control system, and not the source code itself.
>

May I remove the whole "Changelog" with a separated patch?

Thanks
-Bryan
