Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXC1Omn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXC1Omn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXC1Omn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:42:43 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:16025 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752169AbXC1Omn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:42:43 -0400
Message-ID: <460A7EE7.5070101@cfl.rr.com>
Date: Wed, 28 Mar 2007 10:42:47 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux@horizon.com, htejun@gmail.com, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <20070327161616.31448.qmail@science.horizon.com> <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0703271224400.5965@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 14:42:51.0061 (UTC) FILETIME=[5C6CF650:01C77147]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15082.000
X-TM-AS-Result: No--3.572000-5.000000-4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> I would try with write-caching enabled.
> Also, the RAID5/RAID10 you mention seems like each volume is on part of
> the platter, a strange setup you got there :)

Shouldn't NCQ only help write performance if write caching is 
_disabled_?  Since write cache essentially is just non tagged command 
queuing?

