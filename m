Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbYJJQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbYJJQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759921AbYJJQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:29:05 -0400
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:37925 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759446AbYJJQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:29:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=H/1DsluFxWDP8xUGPCmMlKjMu3E8mS9mXzIf3E+yMIBky1dqsn8N8nRTzaWEgM2bpl4Z9oq7GXDnchIyQbku9n/rzix8uzOguzFKIpHGOlqqh8nY0mCW7cpseNyVaXkN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: [PATCH] pci: print out DMA mask info
Date: Fri, 10 Oct 2008 09:28:40 -0700
User-Agent: KMail/1.9.10
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <200810100848.09557.jbarnes@virtuousgeek.org> <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
In-Reply-To: <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100928.41992.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 10, 2008 9:19 am Yinghai Lu wrote:
> another command line parameter for debug?

Sure, why not? :)

> anyway looking at dma_mask print out is interesting..., some uses 39,
> and some use 44bits...

Yeah, many devices have limitations that prevent them from doing full 64 or 32 
bit address cycles, so you'll see all sorts of values.


-- 
Jesse Barnes, Intel Open Source Technology Center
