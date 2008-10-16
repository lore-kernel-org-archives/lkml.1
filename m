Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYJPQYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYJPQYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJPQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:24:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:49685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYJPQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:24:39 -0400
Message-ID: <48F76A8B.6050306@kernel.org>
Date: Thu, 16 Oct 2008 09:23:39 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: n0ano@n0ano.com, donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>	 <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com>	 <20081014233031.GB14490@xolotl.n0ano.com>	 <1224061999.25929.7.camel@test.thuisdomein>	 <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein>
In-Reply-To: <1224153822.3587.23.camel@test.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> On Wed, 2008-10-15 at 14:48 -0600, n0ano@n0ano.com wrote:
>> On Wed, Oct 15, 2008 at 11:13:19AM +0200, Paul Bolle wrote:
>> As an aside, I would personally be in favor of removing the `earlycon'
>> kernel parameter entirely, it seems to be a strict subset of the
>> `console' parameter and anyone that wants `earlycon' probably wants
>> `console' anyway.  Is there a strong argument for keeping that
>> parameter that I'm missing?
> 
> The same thing puzzles me too. Note that earlyprintk=serial|ttyS?[...]
> also provides a similar feature.
> 
>>        earlycon=       [KNL] Output early console device and options.
>> -               uart[8250],io,<addr>[,options]
>> -               uart[8250],mmio,<addr>[,options]
>> +               uart[8250],io,<addr>[,options,[clkd]]
>> +               uart[8250],mmio,<addr>[,options,[clkd]]
> 
> clkd?

earlycon= and conole= share uart[8250]...

the difference console= will start from early console and switch normal console automatically if the ttyS come out with same io/mmio address etc.

YH
