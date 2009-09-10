Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZIJKZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZIJKZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZIJKZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:25:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:21232 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbZIJKZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:25:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,363,1249282800"; 
   d="scan'208";a="447338719"
Date: Thu, 10 Sep 2009 11:19:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090910111957.54255dbb@linux.intel.com>
In-Reply-To: <20090910011320.3a6ec797@caramujo.chehab.org>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910011320.3a6ec797@caramujo.chehab.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> True. Given the idea of using an unique algorithm to populate the
> namespace, I agree that your proposal is a good alternative.
> 
> I just sent the patch with the feedbacks I had. I tried to do my best
> to describe it in simple yet precise terms at devices.txt.

I really wouldn't worry too much. I'm not aware of a single
distribution which still uses the old BSD style pty devices. So its not
as if this is anything but a theoretical problem being addressed.


Alan
