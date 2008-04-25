Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbYDYQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbYDYQlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbYDYQlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:41:46 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:33147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756969AbYDYQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HpKKtY3wryH3OEnJfsVjwDsnjQGh3gWqxSq1lFj44PVfM6M8Qtwhbfo57sGT3GQFhES406vwxeSzkxZQo5V0HbEaMKF6ws8uzBgy5MRdiizyLZ3skpSjXBH4t5Dizbuyhm112osHTdaHnU5xh1vZyK6hIuRGlbjWgn4LhRpvGB8=
Message-ID: <84144f020804250941l63b9d104xc5d2739e479f393a@mail.gmail.com>
Date: Fri, 25 Apr 2008 19:41:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH 1/1] [mm/slob] fix bug - when slob allocates "struct kmem_cache", it does not force alignment.
Cc: "Bryan Wu" <cooloney@kernel.org>, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, "Yi Li" <yi.li@analog.com>,
       "Christoph Lameter" <christoph@lameter.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1209139823.5323.5.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209121041-30524-1-git-send-email-cooloney@kernel.org>
	 <1209139823.5323.5.camel@calx>
X-Google-Sender-Auth: b4e84e7c73c2287c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 7:10 PM, Matt Mackall <mpm@selenic.com> wrote:
>  Looks good, thanks. Christoph, do you want to take this or should it go
>  through Andrew?
>
>  Acked-by: Matt Mackall <mpm@selenic.com>

I'll pick it up in my tree which is "the" SLAB tree for now:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=summary

Thanks.

                    Pekka
