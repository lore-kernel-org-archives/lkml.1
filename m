Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYG2JX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYG2JX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYG2JXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:23:51 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42258 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYG2JXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:23:50 -0400
Message-ID: <488EE175.8040607@parallels.com>
Date: Tue, 29 Jul 2008 13:23:01 +0400
From: Vasily Averin <vvs@parallels.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>	<20080729004756.113d85a0.akpm@linux-foundation.org>	<488ED4CF.1000402@parallels.com> <20080729095122.7021ddd0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080729095122.7021ddd0@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> One of our test nodes uses i2o controller. Now this node have 6 Gb memory and
>> quite a long time it works well under 64-bit RHEL5-based kernel. I'm not sure is
>> i2o card really 64-bit capable, but dmesg shows that it uses 64-bit dma.
> 
> Do you use the i2o config interfaces and driver ?

When I loaded i2o_config module and read all entries in /proc/i2o/ directory the
node hung.

Do you mean that you have fixed this issue?

thank you,
	Vasily Averin
