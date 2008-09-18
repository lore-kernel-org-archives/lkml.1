Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYIRSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYIRSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYIRSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:42:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:55087 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYIRSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xlx4AG74ivE1kpPC8St5JnCcajAaPu4lLIa+XdOm0615/RugNEseF/I0/LlkMzszJv
         zHaupK8BWHpR+sErFRxS7ogHtBrrTFMQVKZs3wbWr4A7P321kKOYda7+mBsGYxKk8+Ar
         SqKx5K27UmOnvsSOhxl5iLNy+t1JTfk2EpLJY=
Message-ID: <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
Date: Thu, 18 Sep 2008 11:42:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
X-Google-Sender-Auth: 5e4ce2e8304a8822
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
> irqpoll is a monster of evil and that should make your system crawl to
> its knees. I would advise instead we work with you fixing the the
> missed interrupts issue upon rmmod.

Also, please provide the output of

cat /proc/interrupts

and also please do not cross post to all these lists, just use
linux-wireless or ath9k.

  Luis
