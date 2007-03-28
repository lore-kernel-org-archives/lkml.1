Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbXC1QQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbXC1QQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXC1QQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:16:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:8947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbXC1QQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=j3ZxVofNYcrLquJ5I+C8uxqBsA/eXovwr4JawYYuejLX5Rl/lbACu8qOrb30P/gc0WXwsFBnBhX8WnBkPiSpb44a0/7Hv1F2BzSuepl073JXTtKL1g4YecUYaInSTaoAR7NVTRJr3J3Q5QaQpCzCBKpdBzf9bfJ8y1k6Icudmgg=
Message-ID: <75b66ecd0703280916v5a9ed49u2f2549a455e832f1@mail.gmail.com>
Date: Wed, 28 Mar 2007 12:16:16 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: John <linux.kernel@free.fr>
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@osdl.org,
       linux-apps@vger.kernel.org
In-Reply-To: <460A297A.2030200@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46094728.40300@free.fr>
	 <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
	 <460A297A.2030200@free.fr>
X-Google-Sender-Auth: f46b6524ca03a552
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, John <linux.kernel@free.fr> wrote:
> Would someone know how to disable SMM in this BIOS?
>

There's no generic way.  Try disabling USB keyboard emulation and any
unused peripherals.  Also google "RTAI disable SMM".

> > Is this a laptop?  They are plagued with SMM problems...
>
> No it is an "indutrial" motherboard.
> Although I don't know what makes it "industrial".
>

One would really hope that such a device would be designed for machine
control and similar RT apps and thus free of SMM...

Lee
