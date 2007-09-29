Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbXI2Iax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbXI2Iax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXI2Iaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:30:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbXI2Iap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:30:45 -0400
Message-ID: <46FE0D29.4090706@zytor.com>
Date: Sat, 29 Sep 2007 01:30:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com> <20070929082233.GA3447@erig.dyndns.org>
In-Reply-To: <20070929082233.GA3447@erig.dyndns.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Both are bad.
> Two different systems and two different bisections.
> I sent the last step of each.

>>> $ git bisect good 
>>> Bisecting: 0 revisions left to test after this 
>>> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
>> OK, so which one is the bad one?
> 
> This problem (no power off) persists after pull some minutes ago.
> Sorry for the confusion.
> 

I believe there must have been something wrong here (possibly
inconsistent experiments?)  This checkin has *zero code changes* from
the previous one (and next one) -- the kernel should have been binarily
identical to the previous one.  The code introduced in this checkin
doesn't even get compiled until two checkins later,
4fd06960f120e02e9abc802a09f9511c400042a5.

	-hpa
