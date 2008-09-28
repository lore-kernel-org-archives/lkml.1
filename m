Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYI1LSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYI1LSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYI1LSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 07:18:39 -0400
Received: from mail.daysofwonder.com ([87.98.213.69]:51668 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbYI1LSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 07:18:38 -0400
Message-ID: <48DF6809.5070202@daysofwonder.com>
Date: Sun, 28 Sep 2008 13:18:33 +0200
From: Brice Figureau <brice+lkml@daysofwonder.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Serial console not working after device detection.
References: <48DE6B6E.4050306@daysofwonder.com> <20080927223353.668d652e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080927223353.668d652e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/08 23:33, Alan Cox wrote:
> Known problem - compile out the PnP serial support

Thanks Alan, that was it.

I recompiled without the pnp serial support and I could finally see the 
messages. Any chance it will get fixed soon?
I had a look to the archives and could only find only a couple of bug 
reports since a few years, so I guess that's not enough pressure for 
anyone to care :-(
I'll file a bugzilla bug report if there is none and a debian bug too, 
that might help :-)

For the short story about my not booting kernels: my issue is related to 
a lilo issue in presence of large initrd or kernels (ie I needed to have 
large-memory set in my lilo conf).

Thanks,
--
Brice Figureau
