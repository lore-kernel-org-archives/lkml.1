Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYGVWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYGVWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYGVWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:11:38 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1907 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754765AbYGVWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:11:37 -0400
Message-ID: <48865B04.6030707@myri.com>
Date: Wed, 23 Jul 2008 00:11:16 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
References: <20080722150438.GK4359@ics.muni.cz>
In-Reply-To: <20080722150438.GK4359@ics.muni.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
>
> the myri10ge driver in 2.6.26 vanila kernel does not work.
>
> Loading the driver produces only:
> [   86.641632] myri10ge: Version 1.3.99-1.347
> [   86.641632] PCI: Setting latency timer of device 0000:07:00.0 to 64
>
> and nothing more.
>   

I have seen one machine with a similar problem. Does reverting
014377a1df693ff30a9e8b69f0bbb0a38e601f75 help? Also could you check that
current Linus' git works fine? (just get the driver source from there,
no need to build the whole tree)

This commit went into 2.6.26 without the final multislice support
enabling, but it was supposed to help anyway...

Brice

