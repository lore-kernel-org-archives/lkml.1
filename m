Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZL3SK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZL3SK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZL3SK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:10:58 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58431 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbZL3SK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:10:57 -0500
Date: Wed, 30 Dec 2009 10:10:46 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
Message-ID: <20091230101046.2816d545@nehalam>
In-Reply-To: <4B3B7488.6080503@majjas.com>
References: <4B300A2A.8040305@gmail.com>
	<4B300E30.9090707@majjas.com>
	<4B3114E3.1070602@majjas.com>
	<4B329FA3.9090904@majjas.com>
	<20091223230102.4bb0100e.akpm@linux-foundation.org>
	<4B34E847.8010809@majjas.com>
	<20091225152200.1cf11dfe@nehalam>
	<4B3581C7.8000702@majjas.com>
	<20091226095723.7ac82b18@nehalam>
	<4B367409.5060202@majjas.com>
	<4B379378.4000102@majjas.com>
	<20091227102238.0df149f9@nehalam>
	<4B37B7E2.5070307@majjas.com>
	<20091229093023.3ad24786@nehalam>
	<4B3A5048.9090700@majjas.com>
	<20091229114938.1f4d1c5c@nehalam>
	<4B3AFFE8.3060409@majjas.com>
	<20091229235942.51bf733d@nehalam>
	<4B3B7488.6080503@majjas.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 10:40:56 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Dec 30 10:37:14 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 30 10:37:14 mail kernel: sky2 Tx ring pending=31...40 report=35 done=35
> Dec 30 10:37:14 mail kernel: 30: 0x0: 0xeb50c0ca(9014)
> Dec 30 10:37:14 mail kernel: 32: 0x0: 0xeb5080ca(9014)
> Dec 30 10:37:14 mail kernel: 34: 0x0: 0xeb5040ca(9014)
> Dec 30 10:37:14 mail kernel: 36: 0x0: 0xeb5000ca(9014)
> Dec 30 10:37:14 mail kernel: 38: 0x0: 0xeb4fc0ca(9014)

You must be using 9K MTU.  Do you see the problem with smaller
MTU?

> Dec 30 10:37:14 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 30 10:37:14 mail kernel: sky2 Tx ring pending=87...92 report=89 done=91
> Dec 30 10:37:14 mail kernel: 86: 0x0: 0xeafd80ca(9014)
> Dec 30 10:37:14 mail kernel: 88: 0x0: 0xeafd40ca(9014)
> Dec 30 10:37:14 mail kernel: 90: 0x0: 0xeafd00ca(9014)
> Dec 30 10:37:15 mail kernel: sky2 0000:06:00.0: error interrupt status=0x8
> Dec 30 10:37:15 mail kernel: sky2 Tx ring pending=39...42 report=39 done=41
> Dec 30 10:37:15 mail kernel: 38: 0x0: 0xe5fec0ca(9014)
> Dec 30 10:37:15 mail kernel: 40: 0x0: 0xe5fe80ca(9014)
> Dec 30 10:37:15 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 30 10:37:15 mail kernel: sky2 Tx ring pending=117...124 report=119 
> done=119
> Dec 30 10:37:15 mail kernel: 116: 0x0: 0xe5d6c0ca(9014)
> Dec 30 10:37:15 mail kernel: 118: 0x0: 0xe5d680ca(9014)
> Dec 30 10:37:15 mail kernel: 120: 0x0: 0xe5d660ca(5938)
> Dec 30 10:37:15 mail kernel: 122: 0x0: 0xe5d640ca(4213)

-- 
