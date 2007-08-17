Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbXHQVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbXHQVb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764038AbXHQV3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:29:40 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:30232 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760643AbXHQV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:29:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=sV68LzzpbVEJQCJdkzXj9FooPNbH/krwtRf283iAWkrkd3gNYocoIAdac/hKBGBqK/8gDe6CtIBUm6TsjCt9VzYbIj1UjrYVtc2KLgVjM/Qm9aKS5mScZoG9V4EXRyXHETVsTc8G6UTvi+fDL3c06+cL3sBKAGSLgyeAsDtBp9U=  ;
X-YMail-OSG: sgTm3UwVM1mdDmAyY5cJMBEB8.7WKVAtpWja6x_sbC4Wcc6eyq01lufXn2Xl_uxd4woMIMF9nw--
From: David Brownell <david-b@pacbell.net>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 02/12] Blackfin arch: Add label to call new GPIO API
Date: Fri, 17 Aug 2007 14:29:31 -0700
User-Agent: KMail/1.9.6
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, "Bryan Wu" <bryan.wu@analog.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <600D5CB4DFD93545BF61FF01473D11AC0D87BDAD@limkexm2.ad.analog.com>
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0D87BDAD@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708171429.31971.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Hennerich, Michael wrote:
> What Mike wants to point out is that a external IRQ is first a GPIO and
> needs to be configured like an INPUT GPIO and then a specific bit needs
> to be set unmask it as IRQ.
> 
> So why not use the GPIO infrastructure to setup this pin as GPIO?

My comments about the advantages of using that infrastructure
for *early* binding captured the key points ... it's "failfast".

For IRQs you're probably on decently firm ground, since it's
extremely rare that people not handle request_irq() errors.

Remember, I just pointed out that the "late fail" strategy
is unusual.  That doesn't mean it's wrong ... just it'll be
a bit of surprise, some cognitive dissonance to developers
picking up a Blackfin project, potentially more error prone.

- Dave

