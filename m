Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDKGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDKGx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXDKGxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:53:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:43287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXDKGxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eyCMIQ2kb64WU2ApnSSA3XX7zhsvvupwNhZmGJwXkInYMQy2SjjCV7dFqZDmz2z1wKOHjZ/hTCHUwPwrGy/gKau4CZ+/zN4V4EkWnQ8bAJH1lVCU2NDEr0Cm2/FSTP5KjPXhlg4XwnUd6bErcNnQ/mtsCREIfWi0VmtbXZR49x8=
Message-ID: <84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
Date: Wed, 11 Apr 2007 09:53:53 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
X-Google-Sender-Auth: 068de678d70b6fea
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Zhao Forrest <forrest.zhao@gmail.com> wrote:
> We're using RHEL5 with kernel version 2.6.18-8.el5.
> When doing a stress test on raw device for about 3-4 hours, we found
> the soft lockup message in dmesg.
> I know we're not reporting the bug on the latest kernel, but does any
> expert know if this is the known issue in old kernel? Or why
> kmem_cache_free occupy CPU for more than 10 seconds?

Sounds like slab corruption. CONFIG_DEBUG_SLAB should tell you more.
