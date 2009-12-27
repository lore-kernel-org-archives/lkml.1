Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbZL0SXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbZL0SXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 13:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZL0SXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 13:23:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZL0SXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 13:23:39 -0500
Date: Sun, 27 Dec 2009 10:22:38 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
Message-ID: <20091227102238.0df149f9@nehalam>
In-Reply-To: <4B379378.4000102@majjas.com>
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
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 12:03:52 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Just an FYI - I left stuff running overnight and saw lots of this this 
> AM... ans one from last night:
> Dec 26 21:39:54 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 27 05:09:39 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008

You have hardware/firmware problem, that is beyond the driver.
That status indicates:
  Parity Error/MAC - "This interrupt is intended to indicate a panic event (hardware fault)"

What is your hardware configuration (lspci, kernel config, memory, cpu)?


