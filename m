Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYG0WNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYG0WNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbYG0WNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 18:13:05 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:41068 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758505AbYG0WNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 18:13:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iclT9lDaolsAG6+8Wgh69V8K1ksEIDk8Pg/sdff7VrW117TC3jhrCKjnB56kFxs2te6KsV8RhBi9by1Um6RIAJjPYLfPMSZKQ4ZlRP+DOQwSEJEmzFoHv0K8Dnc0sYNj09OVPte/WQDRtpGEQkziQMJEplt67w3EUeyqEqdDy/g=  ;
X-YMail-OSG: EwauNe0VM1mlsB1zhZI2aIqoy4FN0QdqI.zTagE01O6LayZZotxz2A.ah_6DZ04rVmtinjDDUKOHLdKtb5_pzYknJDUqDXa6VC379R.JSNtphGQouz74G9wLXYyn70laAkc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH 1/4] [SPI] [POWERPC] spi_mpc83xx: handles Freescale	MPC8610 as well
Date: Sun, 27 Jul 2008 15:12:58 -0700
User-Agent: KMail/1.9.9
Cc: Scott Wood <scottwood@freescale.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Timur Tabi <timur@freescale.com>, Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <20080516165052.GA24196@polina.dev.rtsoft.ru> <20080516190438.GA2758@loki.buserror.net>
In-Reply-To: <20080516190438.GA2758@loki.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807271512.58969.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008, Scott Wood wrote:
> On Fri, May 16, 2008 at 08:50:52PM +0400, Anton Vorontsov wrote:
> >  config SPI_MPC83xx
> >  	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
> > -	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
> > +	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE || PPC_86xx) && EXPERIMENTAL
> 
> How about "depends on SPI_MASTER && FSL_SOC && EXPERIMENTAL"?
> 
> Plus, we should change the option text to something like "MPC8xxx SPI
> controller".

Is there an approved-by-powerpc-folk version of this patch yet?
(Noting that SPI_MASTER is now implicit ...)



