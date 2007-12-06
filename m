Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbXLFT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbXLFT3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXLFT3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:29:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42016 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXLFT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:29:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47584D8C.4090000@s5r6.in-berlin.de>
Date: Thu, 06 Dec 2007 20:29:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: "Jaursch, Bill" <bjaursch@aeshen.com>
CC: Adrian Bunk <bunk@kernel.org>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FW: Guidance on resources for User Space Device Drivers on 2.6
 kernel
References: <32A49E5BEBD67A4F877032926EFAA4D209283BD7@ms08.mse3.exchange.ms> <20071206114912.GL15974@stusta.de> <4757ED3B.1000703@s5r6.in-berlin.de> <32A49E5BEBD67A4F877032926EFAA4D2092CCABF@ms08.mse3.exchange.ms>
In-Reply-To: <32A49E5BEBD67A4F877032926EFAA4D2092CCABF@ms08.mse3.exchange.ms>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaursch, Bill wrote:
> The reason to even consider a driver for this "Software only" driver
> was to start the work of writing a kernel space driver (loadable
> module).  So more specifically, I wanted to know if there is a way
> to use calls to the kernel to access a loadable module that is
> running code in User Space (to take advantage of libraries, tools,
> prevention of kernel crashes, etc.).

Since you plan to use this for a PCI device eventually, it sounds like
UIO would be of help.

> I am running 2.6.20, so many of the new User Space Driver features
> don't appear to be available (UIO, User Space API, etc.).  And at
> this point I don't expect my end users to upgrade to a newer kernel.

Perhaps you can backport UIO or can get someone to do it for you.
-- 
Stefan Richter
-=====-=-=== ==-- --==-
http://arcgraph.de/sr/
