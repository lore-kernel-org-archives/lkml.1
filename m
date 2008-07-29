Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYG2I3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYG2I3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYG2I31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:29:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45346 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbYG2I31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:29:27 -0400
Message-ID: <488ED4CF.1000402@parallels.com>
Date: Tue, 29 Jul 2008 12:29:03 +0400
From: Vasily Averin <vvs@parallels.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk> <20080729004756.113d85a0.akpm@linux-foundation.org>
In-Reply-To: <20080729004756.113d85a0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Alan,

Andrew Morton wrote:
> On Fri, 25 Jul 2008 13:16:37 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> (but could do with more testing, especially on 64bit > 4GB boxes with 64bit
>> capable I2O cards)
> 
> A bit of git-trolling indicates that Vasily might be able to help out
> with a bit of testing?

One of our test nodes uses i2o controller. Now this node have 6 Gb memory and
quite a long time it works well under 64-bit RHEL5-based kernel. I'm not sure is
i2o card really 64-bit capable, but dmesg shows that it uses 64-bit dma.

I'm able to run any tests on this node, however it can take some time.

Could you please explain what tests you want to perform?

Thank you,
	Vasily Averin
