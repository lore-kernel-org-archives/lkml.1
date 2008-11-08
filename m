Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYKHMDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYKHMDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYKHMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:02:53 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46066 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122AbYKHMCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:02:52 -0500
Message-ID: <49157FE7.7040503@euromail.se>
Date: Sat, 08 Nov 2008 13:02:47 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Arjan Opmeer <arjan@opmeer.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se> <20081108005125.GA24783@adopmeer.homeip.net> <49156D54.8060109@euromail.se> <20081108112901.GA12987@adopmeer.homeip.net>
In-Reply-To: <20081108112901.GA12987@adopmeer.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KymWf-00088G-9E.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KymWf-00088G-9E f1953bc446c737164f2a3159043cf3d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The minimum set of data is TOUCH, POSITION_X and POSITION_Y. If touch
>> pressure information is not given in trackpad dimension units, use a
>> specific range.
> 
> The Elantech touchpad does not seem to be able to report pressure, only
> finger coordinates.

I was envisioning a binary TOUCH value, but it is arguably redundant.

>> I believe all current drivers are able to produce this data.
> 
> The Elantech driver is not... :)

So only POSITION_X and POSITION_Y for elantech, then :-)

>> It is designed to bring advanced gestures to the linux desktop.
> 
> Certainly. Have you already thought about the rest of the path from driver
> to application, ie kernel driver -> X.org driver -> X events -> toolkit
> events -> application?

I am involved in the synaptics Xorg driver. I have an experimental Xorg
driver utilizing the multi-touch interface. The plan is to map stable
gestures to the existing toolkit events, removing the need for programs
like syndaemon.

> For instance does the X.org driver interpret the data and emit a zoom or
> rotate event based on the finger position and movement? As far as I know
> those event do not exist and would have to be added to X.org as well as the
> toolkits like GTK+ and Qt. It could be a long implementation process... :(

Every journey begins with a step.

Henrik

