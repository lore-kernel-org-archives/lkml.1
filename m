Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbXI2Wjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbXI2Wjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 18:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbXI2Wjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 18:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbXI2Wjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 18:39:44 -0400
Message-ID: <46FED429.9050200@zytor.com>
Date: Sat, 29 Sep 2007 15:39:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org> <46FE0D29.4090706@zytor.com> <20070929093553.GA4451@erig.dyndns.org> <20070929180721.GA8371@erig.dyndns.org>
In-Reply-To: <20070929180721.GA8371@erig.dyndns.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Hi Peter,
> 
> On Sat, Sep 29, 2007 at 11:35:53AM +0200, Wolfgang Erig wrote:
>> I start again with a fresh tree and better controlled experiments.
> 
> now the result of bisection seems to be consistent.
> 
> The last good commit is
> f2d98ae63dc64dedb00499289e13a50677f771f9 Linker script for the new x86 setup code
> 
> The first bad commit (no power off) is
> 4fd06960f120e02e9abc802a09f9511c400042a5 Use the new x86 setup code for i386
> 
> Now I try the things written in
> http://marc.info/?i=46FD802D.2030804@zytor.com
> 

OK, that makes more sense.  I'll look at this on Monday.

	-hpa
