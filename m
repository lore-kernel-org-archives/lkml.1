Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbXI0XZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbXI0XZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbXI0XZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:25:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:51053 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbXI0XZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sCseJfM0CxrItT0i5pKM2pRQWY/13ITIXfLvQzUkYWU99McOGXka9WB2pUoYnrRY7HZIi+LA8oeH1YZtw21VCdSTZC8HHbQ08H//HGGmld6dlR3wjsq9LwS5LvpwyZkF//xMTJ3rPK5njcsTeIuLSETbUqJFEKbkUTb9kzuiE5c=
Message-ID: <46FC1104.8080105@gmail.com>
Date: Thu, 27 Sep 2007 13:22:28 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>	 <46FB4CB3.3090004@garzik.org> <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
In-Reply-To: <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> Known good is for me 2.6.23-rc3-mm1, the first known bad is 2.6.23-rc4-mm1.
> I will try to look at the diff between these revisions some more, but
> the change in sata_sil24.c looked like a perfect match for the
> symptoms I was seeing.

I think the first thing to do here is to verify 2.6.23-rc3-mm1 still
works fine and my previous debug patch is pretty much meaningless if
address initialization failure isn't the cause.

Thanks.

-- 
tejun

