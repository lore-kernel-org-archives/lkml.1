Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYF0RIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYF0RIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759921AbYF0RI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:08:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:29865 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833AbYF0RI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ooO/wC/OLGBf/NgkYnXOku/kezn21hKLLWupbgNZb9rijb8Bez7Mwkc26N7E1ka0cC
         QhOPj8POnV7SG8S66ZDYbdzMMm/skJ1GCx2rx37OUec7YIqG8m5+uqtUEUaDvetS+puk
         6yzAq5V0tN4TU73IuF1ub8naKdsg/hAldqNtQ=
Message-ID: <9929d2390806271008m633428aeg3fe20b7d67531791@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:08:24 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Taku Izumi" <izumi.taku@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] e1000: make ioport free
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       "Tomohiro Kusumi" <kusumi.tomohiro@jp.fujitsu.com>,
       auke-jan.h.kok@intel.com
In-Reply-To: <4864E5A0.60804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485B1B8E.1060108@jp.fujitsu.com> <485B1C31.4020507@jp.fujitsu.com>
	 <486483DF.5060404@garzik.org> <4864DBE3.3040801@jp.fujitsu.com>
	 <4864E5A0.60804@jp.fujitsu.com>
X-Google-Sender-Auth: 9141035d6218a1b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 6:05 AM, Taku Izumi <izumi.taku@jp.fujitsu.com> wrote:
> This patch makes e1000 driver ioport-free.
> This corrects behavior in probe function so as not to request ioport
> resources as long as they are not really needed. This is based on the
> ioport-free patch of e1000 driver from Auke Kok and Tomohiro Kusumi.
>
>
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> ---
>  drivers/net/e1000/e1000.h      |    4 +
>  drivers/net/e1000/e1000_main.c |   88 +++++++++++++++++++++++++++++++++++------
>  2 files changed, 80 insertions(+), 12 deletions(-)

I will add this into my e1000 queue and push it out in my next
patchset for e1000.

-- 
Cheers,
Jeff
