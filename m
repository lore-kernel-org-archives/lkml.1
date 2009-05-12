Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZELBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZELBu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZELBuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:50:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:7147 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbZELBuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=xe4zwbAOScKQOu+I3b9PlPIBCWU28yV0a97Da4XqQltZBG+bgQTxGaqqnOG12pgEBb
         ozWWE951sz8vr7IqYWM04Tp6sCCG8r5Cd+ld4DfZQlERiPX21CKaFua06WWqqybpwt3M
         LgiuqE2JvEu0LcsAvbV4RtqtmCHvug6VwSQrc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Subject: Re: [PATCH 1/2] Input: tsc2007: fix locking method against the current rc kernel
Date: Mon, 11 May 2009 18:50:00 -0700
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4; KDE/4.2.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <483a38b80905110441t703adbd6sab31bcf19b507fc9@mail.gmail.com>
In-Reply-To: <483a38b80905110441t703adbd6sab31bcf19b507fc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905111850.01096.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kwangwoo,

On Monday 11 May 2009 04:41:35 Kwangwoo Lee wrote:
> Hi Dmitry,
>
> The following patch fixes bug in tsc2007.
> It is not working correctly in the current rc kernels.
> IMHO, this patch should go in the 2.6.30
>

I agree, it is in my for-linus branch now.

> Can you advise me about "From: email" part?
> I splited Thierry's patch. So the original "From: email" is followed:
>
> From: Thierry Reding <thierry.reding@avionic-design.de>
>
> Thank you,
> Kwangwoo Lee
>
> From 749ee3a4a2c2fe1f41601481e47cb26d8ccec20d Mon Sep 17 00:00:00 2001
> From: Kwangwoo Lee <kwangwoo.lee@gmail.com>

This is the last "from" tag in the e-mail so my scripts picked that up.
I adjusted the commit so now it shows Thierry as the original author.

Thanks.

-- 
Dmitry
