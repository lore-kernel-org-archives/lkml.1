Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbYLWNC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbYLWNC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYLWNCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:02:49 -0500
Received: from smtp0.epfl.ch ([128.178.224.219]:41912 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750945AbYLWNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:02:48 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2008 08:02:48 EST
Message-ID: <4950DFE6.2060901@epfl.ch>
Date: Tue, 23 Dec 2008 13:56:06 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>	<Pine.LNX.4.64.0812181414280.5510@axis700.grange>	<20081218225834.GJ20756@pengutronix.de>	<Pine.LNX.4.64.0812221240210.5241@axis700.grange>	<20081222183753.GD1614@pengutronix.de>	<Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
In-Reply-To: <20081223105006.GE1614@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer wrote:
> On Mon, Dec 22, 2008 at 09:10:03PM +0100, Guennadi Liakhovetski wrote:
> 
>> If there are no other problems with v5, could we maybe take it as a basis
>> and then I would submit a patch to reduce the number of IRQs?
> 
> Please understand my concerns with this driver. It's a quite complex
> beast and experience shows that once a driver is in the kernel it is far
> more complicated to change it than to do it right the first way. You
> know that I'm also interested in having a MX31 framebuffer (and camera)
> driver in kernel but I want to make sure that it works properly and leaves
> room for feature enhancements without having to refactor the whole
> driver.
> It would be good if someone else could throw his 2 cents into this
> discussion.
> 

I have been on holiday since last week and I don't really have time to 
comment on all this until my return from great ski weeks, but I have 
been following the discussion very attentively and I will for sure test 
and comment on these patches (camera is very important for our 
application) as soon as I get back to work in January.

It's a bit tricky with this merge window in the "middle" of holidays for me.

Valentin

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
