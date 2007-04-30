Return-Path: <linux-kernel-owner+w=401wt.eu-S1946796AbXD3Ubx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946796AbXD3Ubx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946793AbXD3Ubx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:31:53 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42978 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946792AbXD3Ubv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:31:51 -0400
Message-ID: <46365234.6010804@garzik.org>
Date: Mon, 30 Apr 2007 16:31:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen.Clark@seclark.us
CC: Chuck Ebbert <cebbert@redhat.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20070429161542.GA12501@havoc.gtf.org> <46364901.4000907@redhat.com> <46364C04.4050208@garzik.org> <46364FFA.9050500@seclark.us>
In-Reply-To: <46364FFA.9050500@seclark.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Yeah the kernel will boot but the hd performance is sh*t on my laptop. I 
> am running FC6 with
> kernel 2.6.21 and without the combined_mode setting my disk performance 
> goes down to a
> whopping 1.25mb/sec from 44mb/sec when I boot with combined_mode=libata. 
> It make my
> system unusable!


No, that's the split-driver configuration that causes the slowdown.

Now that both drivers fully support the hardware, either driver can make 
things go full speed.

Please try testing the update first :)

	Jeff


