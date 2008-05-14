Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYENMWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYENMWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYENMWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:22:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:1687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYENMWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JI3LCNzcxN2xIOhbM/EWkBBvFgspCW70ZQUARoOt3WWtyWpAwxYee0MeCPXWbPemeRCuxaeuTPec/FiGJh7Ujd+GUSjUrUM8Wy6HKSBJ/eVrzFlJUQt9s5Jo3YhO/jRtYYNkvN1tFjUXKwIcpZJjr5Jy7gBwVojA46AiZGL2g2Q=
Message-ID: <84144f020805140522m6136ff69w7ffa6f9c9248706f@mail.gmail.com>
Date: Wed, 14 May 2008 15:22:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: [PATCH] kallsyms: fix potential overflow in binary search
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <482AD08D.7070206@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513200736.GA17909@damson.getinternet.no>
	 <482AD08D.7070206@grupopie.com>
X-Google-Sender-Auth: 53e98b85a828551d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 2:44 PM, Paulo Marques <pmarques@grupopie.com> wrote:
> > This will probably never trigger... but it won't hurt to be careful.
>
>  Not "probably", this will never trigger _period_. If you ever have more
> than 2^31 symbols in the kernel's kallsyms table you'll have worse problems
> to worry about than the binary search overflowing.
>
>  So, I don't think it is worth this des-optimization at all...

Yes it is. It serves as correct reference code and the
"deoptimization" is not measurable.
