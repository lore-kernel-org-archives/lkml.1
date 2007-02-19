Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbXBSS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbXBSS73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932486AbXBSS73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:59:29 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:20060 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932481AbXBSS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:59:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wL1bByb1B6xyChoj80eQL5gunTLrafEYRO6eJMO4DD3Wn1K3gyf8S6++wSqlDVY8gQluFJCTAkOFECW4WzOTdzQJ3HqVLPWo61lgh6N+PEW8fXJYUZduq42M4/IC3PRIAV0DXqZL9zenrEo2MOiE4LpNY0EcRmyp5KdQtdG1wW8=  ;
X-YMail-OSG: vrhSzFoVM1mcoXRN10jc7natYPz_XCDtkRVCJ9H79DZ4Ct6Xn8w2pV9lh7gkaHTNcGac3h4pkaK5d.7yNrOLEhxlZvDZqDZLFI_LavKbPa.BMJdF5gPp0DGdVLvi6iO0aL2swKsdcMBrBsc-
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] input/spi: add ads7843 support to ads7846 touchscreen driver
Date: Mon, 19 Feb 2007 10:46:43 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>
References: <20061222192536.A206A1F0CDB@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200702161108.51014.david-b@pacbell.net> <45D99C81.7080401@rfo.atmel.com>
In-Reply-To: <45D99C81.7080401@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702191046.43909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 February 2007 4:48 am, Nicolas Ferre wrote:
>   
> >> -	/* maybe off internal vREF */
> >> -	if (use_internal) {
> > 
> > This part doesn't make sense.  Could you say what you're trying
> > to do?  The ads7846 requres an external vREF.  Is the issue that
> > maybe the REF_OFF command isn't just turning off the (non-existent)
> > internal voltage reference?  If so the comments need updating, and
> > maybe the name REF_OFF needs to change too...
> 
> Well, on the ads7843, this command allow to put converter in low power
> mode and, more important, enable the PENIRQ (otherwise disabled).
> 
> The REF_OFF command can be replaced by the PWRDOWN one (exactly the
> same command). This last name matches better the ads7843
> datasheet description (and seems ok considering the ads7846 one).

OK, that would be a better change then, along with comment update.

- Dave

