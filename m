Return-Path: <linux-kernel-owner+w=401wt.eu-S1765772AbYD3WM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765772AbYD3WM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbYD3WMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:12:15 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:47988 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754958AbYD3WMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:12:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=v2mkggOQLx0Qf8X6Z2PrngO+9py1w0CC0lmrPGZp1lD+QLMt6Kgqj3I+4XJ90XKAJdYYbhs6chRszSUJQFuRatkvj70kWDgzfk9mxxBgzcS/QwL9c0uzA7xzPELHlHuvTFs/WkOmNOMLqC8GiiJjVWa8Q0w9iaC/2KcCH1MUNPQ=  ;
X-YMail-OSG: lhr.vdwVM1n2d6nuQ1QHkMwg.ME228qa7vqflpKKpf..vNnhHn25RZ2s3U016n4ziSyOQE7V9KTM.2SdqZ7yqfF2IljaphscZG8DfljOIwUCDW60MzrQNoey6tnqbIh_GF8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH] spi_mpc83xx: test below 0 on unsigned irq in mpc83xx_spi_probe()
Date: Wed, 30 Apr 2008 15:12:10 -0700
User-Agent: KMail/1.9.6
Cc: Kumar Gala <galak@kernel.crashing.org>, Roel Kluin <12o3l@tiscali.nl>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <480F99D5.7070300@tiscali.nl> <7C711FFF-E1C5-4286-93A8-382055C6760C@kernel.crashing.org>
In-Reply-To: <7C711FFF-E1C5-4286-93A8-382055C6760C@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804301512.11317.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Kumar Gala wrote:
> 
> On Apr 23, 2008, at 3:19 PM, Roel Kluin wrote:
> > mpc83xx_spi->irq is unsigned, so the test fails
> >
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Any reason to not just make mpc83xx_spi->irq be "int",
following normal practice everywhere?  If not, I'll
roll that into the patch from Joakim Tjernlund...

- Dave
