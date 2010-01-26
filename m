Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350Ab0AZVDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0AZVDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184Ab0AZVDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:03:06 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:37206 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752699Ab0AZVDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:03:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rwf2nlKXCwR9y/chLzeJQ9AHuB7sZQx+lAQBtrsW5RFyx/nf7HNl4/wYIbnHooCQ2EBNh6WAT9LsnMvuFjugL8CAdoB5Hx338CFqjNZRwubbvJ7dh5xEhZFSgCLHNaGXJOxtauL8hMGTimxD3/Vaaj4fBZdiF58n9WDBbV0/HCU=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: x1.rj54VM1kN7w1Mcp6dEZaR2y0lJfxNdXdwUMRqUB4Fhim9_C5ntBo2tyhtTmKIs7uzf1cLIkIZAIS0kQNRkOcpV0QxK9.ewCIdcxv42jCh4NuPQz4XHPpYOG39IkeMPO_u5YC0f1gQOASOoPbMqUKQYlW_Qdh0v4Bhyk.XQHlEYlFcj7YVkrmh1E73nrtiRmFT48uZCoyyfHe73xkBDxO4wuQ88bvN_UloJr_QhsBJ542k1HWLTNIRUn_AG0O2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 2/4] of/gpio: Add support for two-stage registration for the of_gpio_chips
Date: Tue, 26 Jan 2010 13:02:43 -0800
User-Agent: KMail/1.9.10
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru> <201001252236.16141.david-b@pacbell.net> <20100126174347.GB20319@oksana.dev.rtsoft.ru>
In-Reply-To: <20100126174347.GB20319@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001261302.44424.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Anton Vorontsov wrote:
> 
> > Why have two options, instead of just the first/simpler one??
> 
> Because I2C/SPI drivers allocate (and register) gpio_chip structures
> by themselves, so the first option is a no-go.

You should be mentioning such issues in the patch comments.
