Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXKBFQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXKBFQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXKBFQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:16:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41175 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXKBFQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:16:31 -0400
Message-ID: <472AB2AD.3040709@garzik.org>
Date: Fri, 02 Nov 2007 01:16:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata ATAPI transfer size cleanups
References: <20071101090733.GA9258@havoc.gtf.org> <64bb37e0711011251w255746c7x6947f85431d4f4fe@mail.gmail.com>
In-Reply-To: <64bb37e0711011251w255746c7x6947f85431d4f4fe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 11/1/07, Jeff Garzik <jeff@garzik.org> wrote:
>> +       lo = tf->lbam;
>> +       hi = tf->lbam;
>> +       ibyte = (hi << 8) | lo;
>> +
>> +       lo = result_tf->lbam;
>> +       hi = result_tf->lbam;
> 
> That doesn't look right.
> I suspect this was intended:
> 
> lo = tf->lbam;
> hi = tf->lbah;

Agreed, will correct.

Thanks,

	Jeff



