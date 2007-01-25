Return-Path: <linux-kernel-owner+w=401wt.eu-S965305AbXAYNNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305AbXAYNNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXAYNNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:13:44 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32533 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965152AbXAYNNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:13:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WNhwkpuNksNywsRkYX2XTb3CuCQGRpGuZFLapJ85Ni0dcsnNz60YHNDssCquDlFI0hymRuRHsCnlDqA738ZspR10i1m47VdiC6Eh1CJkTZ4YpjXOjmrWU+pMc5VyRCiYquu5be72qFEobj1bOn6UlOJ/Y/2LLion1eh1U6ycFyk=  ;
X-YMail-OSG: aBIZuB8VM1ktScc5fzTdAgPmDK8BJPLgCQO.J6kiCBB7spg0QgQ6wDAbsAWgWLbs.q6nDFUdHDVJSTOS5GjlhKDP6qeZthPKPX7W55mPiJmYOSnM5Fr.4RrlsS1SypEwzggGCshFywK7WavBrWQSJK7nP6CCBtpJ
From: David Brownell <david-b@pacbell.net>
To: "Hans-Peter Nilsson" <hans-peter.nilsson@axis.com>
Subject: Re: 5 patches: updates to SPI and mmc_spi, kernel 2.6.19
Date: Thu, 25 Jan 2007 04:59:37 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701250447.l0P4lvNX016943@ignucius.se.axis.com>
In-Reply-To: <200701250447.l0P4lvNX016943@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701250459.37728.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 8:47 pm, Hans-Peter Nilsson wrote:
> (Please CC me on replies, I'm not subscribed to LKML.  Thanks.)
> 
> Five SPI-related patches follow.
> 
> 1: bugfix for spi_bitbang: always call the setup_transfer
> function via the overridable pointer.
> 
> 2: Allow clocking SPI with chip-select inactive.
> 
> 3: Define the bit-value transmitted for SPI transfers with no tx_buf.
> 
> 4: Update of David B.'s (et al) kind-of-proof-of-concept
> MMC <-> SPI glue driver mmc_spi posted on Aug 1, found at e.g.
> <URL:http://www.gossamer-threads.com/lists/linux/kernel/671939#671939>.
> 
> 5: SPI cleanup should not have const on its argument.

Cool ... two of those (#1, #5) seem ok to merge right now, and
I expect that #2 can go in with only minor tweaks.

#3 needs more attention (see my response) and I'll have to look
at #4 soon.

Thanks for looking at this.  I know various folk have needed to
have MMC/SD working over SPI for some time, and was hoping that
someone else would make time to take that code the next few steps
on the way.  Just like you did!

So to summarize ... you now have MMC-over-SPI working on CRIS
hardware, with these patches?   Can you yet run filesystem
stress tests with ext3 on such an MMC card, or is this more at
the level of everything working with light/early test loads,
so it's time to see if other folk can reproduce your results?

- Dve
