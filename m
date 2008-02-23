Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbYBWT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbYBWT67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYBWT6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:58:46 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:4270 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762080AbYBWT6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=ptDTEaQooJPcbZSkBrNOLgwOnloar8Dl4zDlAqzPTPZqFM1rhYEQgeJjlebcSkzDu63vLFW0IiDcg9DO+OGxpDn8+a6zwPP25SJyaNGIh3YUmyUm2SZSVuwsjKRRjFVTi1WFMKpEHtJM1sveBU6BqkpAX+yTH87ks/T4VVX1n/Y=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Andi Kleen'" <andi@firstfloor.org>
Cc: "=?ISO-8859-1?Q?'Ilpo_J=E4rvinen'?=" <ilpo.jarvinen@helsinki.fi>,
       <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "'David Miller'" <davem@davemloft.net>,
       "'Arnaldo Carvalho de Melo'" <acme@redhat.com>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>	<20080223000220.e9229c99.akpm@linux-foundation.org>	<p734pbz95lx.fsf@bingen.suse.de> <20080223105517.4d706511.akpm@linux-foundation.org>
In-Reply-To: <20080223105517.4d706511.akpm@linux-foundation.org>
Subject: RE: [RFC PATCH 0/8]: uninline & uninline
Date: Sat, 23 Feb 2008 11:58:30 -0800
Message-ID: <00ac01c87656$777c02a0$667407e0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ach2TiA2SKUARlY2TeGDpaIOhzNQLQABzqXg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is there any reason they couldn't just be merged to mainline?
> >
> > I think it's a useful facility.
> 
> ummm, now why did we made that decision...  I think we decided that
> it's the sort of thing which one person can run once per few months
> and that will deliver its full value.  I can maintain it in -mm and
> we're happy - no need to add it to mainline.  No strong feelings
> either way really.

Apparently nobody has been doing it for a while. :-) Last time I did it it
was around the submission time and I actually patched it into mainline
kernel to do so. Not particularly hard to do, but sitting in mm-only does
make it a bit harder, and there are the vdso problem you just mentioned that
one has to fix for himself if it exists in mainline.

> It does have the downside that the kernel explodes if someone adds
> unlikely or likely to the vdso code and I need to occasionally hunt
> down new additions and revert them in that patch.  That makes it a
> bit of a maintenance burden.

Is it possible to catch this automatically, like, by re-defining
likely/unlikely to the raw form in specific file(s)?

Hua


