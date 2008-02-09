Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYBIQeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYBIQeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYBIQdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:33:52 -0500
Received: from qb-out-0506.google.com ([72.14.204.232]:40327 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYBIQdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YsgI7zti8Xb2X+SNdtnxLkD3UbkelmWFL68vsjhNMjwujB2VOixZMtpYXqDuGnihnQbgxxCJK+GmlHg0Zg0247xlbPjDxRGXpUPyEW+fdgV5m+2tKRUQWA2D3ABif4w6Mew1RhOE3Obf8D9JTShHlUET/ij5DNv91vEHcjfOAig=
Message-ID: <2f11576a0802090833h7a600ee8x87edb423cbbb5d79@mail.gmail.com>
Date: Sun, 10 Feb 2008 01:33:49 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Zan Lynx" <zlynx@acm.org>
In-Reply-To: <B846E82A-D513-40CD-A19C-B60653569269@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
	 <B846E82A-D513-40CD-A19C-B60653569269@jonmasters.org>
X-Google-Sender-Auth: 128a6bd6d48dd66d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Interesting patch series (I am being yuppie and reading this thread
> from my iPhone on a treadmill at the gym - so further comments later).
> I think that this is broadly along the lines that I was thinking, but
> this should be an RFC only patch series for now.

sorry, I fixed at next post.


> Some initial questions:

Thank you.
welcome to any discussion.

> Where is the netlink interface? Polling an FD is so last century :)

to be honest, I don't know anyone use netlink and why hope receive
low memory notify by netlink.

poll() is old way, but it works good enough.

and, netlink have a bit weak point.
end up, netlink philosophy is read/write model.

I afraid to many low-mem message queued in netlink buffer
at under heavy pressure.
it cause degrade memory pressure.


> Still, it is good to start with some code - eventually we might just
> have a full reservation API created. Rik and I and others have bounced
> ideas around for a while and I hope we can pitch in. I will play with
> these patches later.

Great.
Welcome to any idea and any discussion.
