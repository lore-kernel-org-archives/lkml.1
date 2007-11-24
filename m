Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbXKXS43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbXKXS43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbXKXS4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:56:22 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:46025 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752024AbXKXS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:56:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U2xo6eStDSblBN439v449FmidjcRBGs8K2Ltgz9zOlrs5ZLcyiAkf2cIucV9mL7m1YFxwFtnBDNpX+BiAUfW+g1Wr3DD7oBgXN2w9AlrULHelp7GqVmrbKi5ZjWZ9o+mt5S8DSud8Krht+2vFk3Y9KXd5WkFBCPzp2WPr/iZf0I=  ;
X-YMail-OSG: epgVOE0VM1lbQm.WSo9i8Otsh1ZHQqadKLWH1fCD2qS9Xpkl
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC 4/4] Atmel MCI: Driver for Atmel on-chip MMC controllers
Date: Sat, 24 Nov 2007 10:48:39 -0800
User-Agent: KMail/1.9.6
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <1195820413-2179-1-git-send-email-hskinnemoen@atmel.com> <20071124180023.20c831b8@poseidon.drzeus.cx> <20071124191648.2c2d56c7@siona>
In-Reply-To: <20071124191648.2c2d56c7@siona>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711241048.39990.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 November 2007, Haavard Skinnemoen wrote:
> > 
> > Why is this needed and is it perhaps something that can be moved to
> > the MMC core?
> 
> We used to have lots of problems with overruns and underruns and those
> parameters were useful to limit the transfer rate. Now that the RDPROOF
> and WRPROOF bits seem to have taken care of these problems for good, I
> guess we can remove this parameter.

Not all silicon *has* those bits though, right?  Like at91rm9200.

