Return-Path: <linux-kernel-owner+w=401wt.eu-S965018AbZLGUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbZLGUtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935593AbZLGUtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:49:31 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64161 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935592AbZLGUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rGn6zR7mKcpYnUDPFJY681RHIrMpE9uT/6s+vmQ6Ibh+M+LagfQYMDA+bWGQ4vIu5s
         qVceIRQ9gfG8AlCIrc0t584kLGN2MR/v8zLVGBmbMMHSFddC+PYWe/DIdF8WlToYFcig
         5gpHrtWdGiaFeHKquSGsnadhY+kqqwSlTYGaM=
MIME-Version: 1.0
In-Reply-To: <c0c067900912022016u32e393cw3fe9e04ba1051253@mail.gmail.com>
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
	 <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com>
	 <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
	 <4B0DDFDA.1030905@redhat.com>
	 <c0c067900912022016u32e393cw3fe9e04ba1051253@mail.gmail.com>
Date: Mon, 7 Dec 2009 15:49:33 -0500
X-Google-Sender-Auth: e4f4920bdfb3fae3
Message-ID: <c0c067900912071249y68c4c2bby90202bd5f467ea2c@mail.gmail.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
From: Dan Merillat <dan.merillat@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
       Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Can you try out the patch from
>> http://lkml.org/lkml/2009/11/25/467 ?

After a week of testing, that seems to have been the issue, thanks!
