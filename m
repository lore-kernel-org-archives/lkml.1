Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXEaDYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXEaDYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbXEaDYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:24:34 -0400
Received: from rtr.ca ([64.26.128.89]:3887 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbXEaDYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:24:33 -0400
Message-ID: <465E3FF0.9010709@rtr.ca>
Date: Wed, 30 May 2007 23:24:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
In-Reply-To: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> I have a SanDisk Extreme IV 4GB CF card, capable of 40MB/s read, but
> am seeing 30MB/s read [1], connected directly to the IDE bus on my
> ICH8 controller.
> 
> How can I find out if this would be a timing or configuration issue?
> On 2.6.20.5 [2], the 120nS timing looks to be right [3], but perhaps
> no multi-word transfer is hurting here...alas, it can't be enabled
> with the libata subsystem and 'hdparm -m', so what else?

Please post the output from "hdparm --Istdout /dev/sdb" for this card.

Thanks
