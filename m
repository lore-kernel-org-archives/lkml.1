Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZDNRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZDNRg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDNRgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:36:16 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41645 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751314AbZDNRgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:36:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S68/SlW6zvPJE691Y32Qyzuqp8svCGTLCwWEmsA19dx7G3hojUVNvNdgmnvV0Yj4XqxNNk0nAIyfCShi9M9xYxFnV2/lftYAa5o0fnVefo1qBusXJn7/E7c40+S7a0PCtIGmoB7//3SBc8GJLTuOmlzaiog3PHb68gsbm0+dxlM=  ;
X-YMail-OSG: pD.UMn4VM1mYvFrXoNhAU9BDQuJfqM4IGrFXl0aEq3_EdlEteVqulzETZAG73fkxh6CDmnxbMkLEwijPM2SMnpMxOokCTrBwXfYorDLXY5mSI7YXLboLLoHvzS8Mq6e.EY_aRuyabYR36ZKB0IwxGbd71dvpkMZVzrCV7zvW3vXQSN0dhUDuSWnGpL.SSjQ7NG0poFMX9ORCTda1w8NnLT0kiO.MlEnI2YwGM496lZCm62qayKQ_1qyN5mkvBMnPngTILXtmhqxqzLJY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Date: Tue, 14 Apr 2009 10:36:13 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com> <7A436F7769CA33409C6B44B358BFFF0CFFAA9253@dlee02.ent.ti.com> <200904071546.14898.david-b@pacbell.net>
In-Reply-To: <200904071546.14898.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904141036.13325.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, David Brownell wrote:
> > 
> >  I have not sent the actual NAND driver to the linux-mtd yet, since
> >  the initial version (supported only 1-bit HW ECC) submitted by David
> >  Brownell was still in review (no comments and not approved yet).
> 
> It merged to mainline yesterday; should verify on DM6446 EVM.

For the record:  it seems to have merged OK, and the resulting
driver passed all the mtd tests I threw at it.  Current mainline
Linux and U-Boot interop through that small-page NAND just fine.

- Dave
