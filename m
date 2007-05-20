Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbXETGRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbXETGRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759119AbXETGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:17:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:20290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758937AbXETGRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:17:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AouBBlgdRgAYcMHy6RXwlEEvVVhNPNo/4Z1ImPKqYvwJ25/p6NaXPdozPTwofVYzE7C3IoA3bTDgJshSuefDNPQNJhNDFX3JB0K4LTlehurhXkSDBdG1cXjk3mdKlf+r2YLoIHyID8C9dR6OOCufym4KsGOuyrCvQNhT1gGob7U=
Message-ID: <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
Date: Sat, 19 May 2007 23:16:59 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andrey Borzenkov" <arvidjaar@mail.ru>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, "Ken Chen" <kenchen@google.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <200705200845.43621.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
X-Google-Sender-Auth: f195ccb9fd9d0715
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> On Sunday 20 May 2007, Uwe Bugla wrote:
> > unfortunately it does not make any difference if I simply rip out the
> > changes of patch-2.6.22-rc2 or patch-2.6.21 in connection with patch
> > 2.6.22-rc2 regarding module loop.c.
>
> because they are just followup to the real cause. This is causes by commit
>
> commit 73285082745045bcd64333c1fbaa88f8490f2626
> Author: Ken Chen <kenchen@google.com>
> Date:   Tue May 8 00:28:20 2007 -0700
>
>     remove artificial software max_loop limit
>

Yeah, that's the only one left. I was hoping it wasn't that one, as it
claimed to have been tested extensively. Guess it wasn't tested with
udev.

Ken? Ball's in your court. As the patch isn't providing a killer
feature for 2.6.22, I'd suggest just reverting it for now until the
issues are ironed out.

Ray
