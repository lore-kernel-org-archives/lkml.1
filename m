Return-Path: <linux-kernel-owner+w=401wt.eu-S1762876AbXFRNPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762876AbXFRNPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFRNPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:15:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:6011 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbXFRNPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O5uzY4Od2qscDDit2FI5wgegLHaPScdPm5PQNsA9YqPdm9Y9/D+WNB3Us3Q2LXwgZNqKyDInyw2s6bGYJ23mlBLoYYFVLJQTVP7VthOdDBTo8hNCdOikS3s3m6lr+xLU9iLQ9i5ZTYIffOiHu+leGbQ2jIj/yAl/+shrcHkF+cw=
Message-ID: <625fc13d0706180615t2f327b16rf648b2ee56da6ed9@mail.gmail.com>
Date: Mon, 18 Jun 2007 08:15:37 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC] [PATCH] selective signal ptracing
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, john.blackwood@ccur.com,
       linux-kernel@vger.kernel.org,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>, bugsy@ccur.com
In-Reply-To: <20070617012952.09F2D4D059F@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182039062.26853.111.camel@localhost.localdomain>
	 <20070617012952.09F2D4D059F@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/07, Roland McGrath <roland@redhat.com> wrote:
> > What are the issues with arch like ARM ?
>
> The interesting class ARM belongs to is machines that don't (or don't
> always) have hardware support for single-step.  Maintaining the status quo
> of how PTRACE_SINGLESTEP functions on these machines is different in
> implementation under utrace than it is for machines that always use
> hardware support.  That is the only special complication for ARM, and it is
> not really very complicated.  Apparently the way I described the issue in
> the past was easily misunderstood.

That isn't just ARM.  There are some embedded PowerPC chips that lack
an easily usable hardware single step.  Just an FYI.

josh
