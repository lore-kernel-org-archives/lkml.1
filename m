Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXBNNlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXBNNlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbXBNNlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:41:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:29652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXBNNlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:41:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sQILtMaFzuW+spV7uD3I3nHVR10v+qLevO4xLy4LGa9KufUCYNZgJmmzTWPkkwsv7K2mSwNzwX89yNuexhf1MO/fAhPYmdPTAfZCVpDM8QMlUxD9LVqfTL7MsyJjucKeXxWOvTRkZb/rD6pMmSRaWQ0/KGtDXB31Gm25JzQi6t4=
Message-ID: <acd2a5930702140541n20752906ge1ff58efed460ed5@mail.gmail.com>
Date: Wed, 14 Feb 2007 05:41:53 -0800
From: "Vitaly Wool" <vitalywool@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] 8250: make probing for TXEN bug a config option
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070214004755.faa96e55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061226194317.3fd3ec14.vitalywool@gmail.com>
	 <20070213224643.14d27cd3.akpm@linux-foundation.org>
	 <acd2a5930702140037yff0b77dl2714ea7869bdde54@mail.gmail.com>
	 <20070214004755.faa96e55.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 14 Feb 2007 11:37:52 +0300 "Vitaly Wool" <vitalywool@gmail.com> wrote:
> > Hmm, why? I can't think of a platform where one 8250-compatible UART is
> > problematic and another isn't :)
> >
>
> Is it not possible that the same kernel package can be installed on systems
> which do and don't need this feature?  If so, we don't want to force the
> provider of that package to create two packages.
>
> That, plus the chances of the package creator actually knowing about this
> option aren't great.
>
> Generally, if it can be done at runtime it is better to do so, no?

Okay, yes, I see your point. The same kernel might actually be
supporting several machines.

But having that as a config option doesn't look too attractive to me.
What about adding a new flag to plat_serial 8250 stuff instead?

Vitaly
