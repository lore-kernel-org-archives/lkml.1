Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbXKZO6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbXKZO6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXKZO60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:58:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:7371 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXKZO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J0YT9li9q2Wscw7YXAXAmlsw2qcPjslPB2l7iLOwM0F7yDM3et5VgffJXI9OA7FgHRwJ2GOZzXDrB1HLiUOprRk8rFQSwSabbXFywXIIJdwNjNFcY4A6Km9vLdjrzR3WLmx/lpeBJkC3hYJqWnbmDAgcmFiIMyZMfrMPbU+J+2s=
Message-ID: <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
Date: Mon, 26 Nov 2007 06:58:23 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: can support for "rpm"-based package building just be dropped?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
X-Google-Sender-Auth: 4ad6ae157a28e94f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 26, 2007 12:54 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>   on current systems, "rpm" no longer has build capability and will
> fail thusly:
>
> rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
> --target: unknown option
>
>   so it would make more sense to just require "rpmbuild" on the
> machine, would it not?

Only on current machines. You'd break building kernel RPMs on older
systems that don't have rpmbuild installed. So the change wouldn't fix
anything, and would break some non-zero number of setups that are
currently working, making the change a guaranteed net loss.

A patch that added version checks against rpm and whinged
appropriately about needing rpmbuild would likely be accepted, though.
