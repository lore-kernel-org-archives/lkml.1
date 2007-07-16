Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXGPXzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXGPXzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXGPXzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:55:25 -0400
Received: from wilma.widomaker.com ([204.17.220.5]:2788 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbXGPXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:55:25 -0400
Date: Mon, 16 Jul 2007 19:55:22 -0400
From: Charles Shannon Hendrix <shannon@widomaker.com>
To: linux-kernel@vger.kernel.org
Subject: sata_nv: 2.6.22 is not fixed, but certainly improved
Message-ID: <20070716195522.5ea906ea@daydream>
Organization: Multi Endian
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just compiled 2.6.22.1 on my Kubuntu 7.0.4 system.

As before, I get errors using my Seagate SATA drives, and setting adma=0
fixes the problem.  I've posted the exact error/reset messages several times
before.

However, I would like to note that it happens far less often with 2.6.22.1
than it did with 2.6.21.

The history on my own machine is like this:

	2.6.19	perfect, but of course no ADMA/NCQ
	2.6.20	horrible, with hard resets starting immediately upon
		boot, and taking 15 minutes to finally disable NCQ
	2.6.21	bad resets, but they only occured ever 10-30 minutes,
		NCQ never disabled
	2 6.22	resets infrequent, they are soft resets, and much
		quicker than before (i.e. less interruption of my usage)
		NCQ is never disabled

I have no idea why I might be seeing a gradual reduction in the severity of
the problem, but it seems worth noting.

I want to point it out in case it means something to anyone working on
the kernel, especially the SATA code and drivers.

In the last 4 hours of use, I've seen a single reset.

On all previous kernels under the same load, I'd already have seen several of
them, or with 2.6.20, a constant stream of them.




-- 
shannon           | An Irishman is never drunk as long as he can hold onto 
                  | one blade of grass and not fall off the face of the earth.
