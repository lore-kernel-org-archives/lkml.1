Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXBJUnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXBJUnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBJUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:43:06 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64227 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbXBJUnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:43:05 -0500
Message-ID: <45CE2E54.7060101@student.ltu.se>
Date: Sat, 10 Feb 2007 21:43:00 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic	boolean-values
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se> <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1171132062.3373.31.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sat, 2007-02-10 at 18:46 +0100, Richard Knutsson wrote:
>   
>> Convert:
>> FALSE -> false
>> TRUE  -> true
>>     
>
> Actually, downcasing true and false in this driver is pretty much a
> retrograde step.  The reason for their being uppercased is that they
> represent constants (and uppercase is the traditional defined constant
> specifier).
>
> When discussion about TRUE and FALSE came up a long time a go in the
> context of the mid layer we agreed to strip the defined constants out of
> that code and just go with 1 and 0 inline ... because the code was
> pretty much being rewritten.  We also decided to encourage but not force
> the driver writers simply to use 1 and 0 as well ... a lot of people are
> deeply wedded to the TRUE and FALSE defines, it turned out.
>   
Btw, is this just for aic7xxx_old and not aic7xxx? Is it going to be 
replaced? In that case, I will just leave it alone.

Richard Knutsson

