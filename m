Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYEZW1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYEZW1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYEZW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:27:03 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:45606 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755419AbYEZW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:27:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nATkD3Jzp+KpaeJE1qq3AC3UP6TnYQ08reo4YCZOPjierOxAnguLi1jcpNKZHCup0HeVPjydgPR3hl7EZQ8x+JBu6H9q2bJR/2kCFUrXTFeTdsIUXU32IutF212O2PRAG03t36Z8aZ/kiRaiTz2/UdL8VtvkETSkhSEXrlWluK0=  ;
X-YMail-OSG: Fg8hXX8VM1lSevMYVlvS8OxRbuQI7acyxr30kJtsmq9_f2FW3vrWLNO_nHvFxCnGcnAYs1C6xf9KCLeTQ_EQk_SRZ1.84eIpA04rZWno8irse34yCA_L0J360D4VgAZevLg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [RFC PATCH 2/2] mmc: add OpenFirmware bindings for the mmc_spi driver
Date: Mon, 26 May 2008 15:19:01 -0700
User-Agent: KMail/1.9.9
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Segher Boessenkool <segher@kernel.crashing.org>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <fa686aa40805232219x7e888d80y394958f1c0a0fad0@mail.gmail.com> <20080526114914.GA26288@polina.dev.rtsoft.ru>
In-Reply-To: <20080526114914.GA26288@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805261519.01735.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008, Anton Vorontsov wrote:
> David, would you [not] suggest us to use platform_data with
> container_of, that is, are there any plans to make SPI core copy
> the platform_data instead of passing a pointer directly?

No such plans.  How could it copy, not knowing the size?


