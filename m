Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXKNLDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXKNLDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXKNLDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:03:08 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43457 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752298AbXKNLDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:03:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W5pZYvaCdtx90shhOyK31r9fSS2rrFo/4I3blJ/yWeD2mkxZfnqvpewLvIY9nh9OnHeSDwFqkwwrYgdSTj7PRzxNa3/JbPu3UBclaxLdumENqwJztDnESMHQQaSpK5bJ0VexWV+JPpLg41wFNm5+agu/LZJA5nFw1FR0t/lrFoA=  ;
X-YMail-OSG: 37sK4jsVM1mWsUupbW5ap2lv6tSZZurgs4CzMZOTdgavbQxE
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Wed, 14 Nov 2007 09:55:03 +1100
User-Agent: KMail/1.9.5
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
References: <200711140436.24492.nickpiggin@yahoo.com.au> <20071113.223726.40898879.davem@davemloft.net> <200711140927.39796.nickpiggin@yahoo.com.au>
In-Reply-To: <200711140927.39796.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140955.03989.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 09:27, Nick Piggin wrote:

> > 2) Try removing NETIF_F_SG in drivers/net/loopback.c's dev->feastures
> >    setting.
>
> Will try that now.

Doesn't help (with vanilla kernel -- Herbert's patch applied).

data_len histogram drops to 0 and goes to len (I guess that's not
surprising).

Performance is pretty similar (ie. not good).

I'll look at allocator patterns next.
