Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXI2Wa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXI2Wa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 18:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbXI2WaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 18:30:16 -0400
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:29329 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753861AbXI2WaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 18:30:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TGJE/IJ79xXCjwMxxI22kkJFAIdLMpPpf1vXpuAQx2yOI5O5I56m2rZbHzrOwGJ07e2RGWKkWyrlifIOyxUdwYAhM9vnReJsbzAbFl12FODNXSPcxMmkyBQHk/tAEK6JWUA+LlgDrmTAA74JXJ3uo1ffFDjurnocc/A8ipg0rNs=  ;
X-YMail-OSG: 1JM8sq8VM1lOkqCZQRIM1_flMBkp7CiaTk.P04wPij2iPgrZCMwxMxw6bUoE7_SsZvimnVzbK565m7bisHiO5jZiAqC_QMqZIUEJ8geFO8C.P9oyMjKSnaFBzEvXdaFlEvL7EpcOTIBivI0-
Date: Sat, 29 Sep 2007 15:30:15 -0700
From: David Brownell <david-b@pacbell.net>
To: randy.dunlap@oracle.com
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, akpm@linux-foundation.org
References: <20070929122530.5c45f743@hyperion.delvare>
 <20070929035156.cd6fe860.akpm@linux-foundation.org>
 <20070929112928.56a04641.randy.dunlap@oracle.com>
 <20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20070929131317.6a8609dc.randy.dunlap@oracle.com>
In-Reply-To: <20070929131317.6a8609dc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070929223015.7F052236A50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Let's kill it, please.  (i.e., ACK)
> > 
> > But ... why?  What value could needless parens provide?
>
> Who says that needless parens could provide value?

Jean, which is why he submitted the patch.
You, implicitly, by acking a patch saying those parens are bad.
But not me ... I don't think this patch is merge-worthy.


> > "Yet Another Subtle And Hard To Fix Source Of Bloat" is
> > not a plus.
>
> ISTM that we agree.

Evidently not, since removing it would promote such bloat.
Explicitly removing disapproval is a form of approval...


> > I'd kind of think a change like this should have some
> > positive motivation.
>
> "Me, I agree that numbers in parens don't usually make sense for
> kernel messages."
>
> It's too trivial to be included in CodingStyle.

So the reason to remove that guideline, and thereby encourage
proliferation of needless parens, is ... that some OTHER way
to get rid of them is working?

I would agree that line could be improved to say that messages
should not be needlessly large.  Excess parens are one example;
wordiness is another (including printing 8 bit fields as 0x%08x),
and I'm sure there are more.

