Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbXCRTSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbXCRTSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 15:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXCRTSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 15:18:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38770 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbXCRTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 15:17:59 -0400
Subject: Re: forced umount?
From: Arjan van de Ven <arjan@infradead.org>
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 18 Mar 2007 20:16:19 +0100
Message-Id: <1174245379.3538.252.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 23:06 -0500, Mike Snitzer wrote:
> I'm interested in understanding the state of Linux with regard to
> _really_ forcing a filesystem to unmount.
> 
> There is a (stale) project at OSDL that has various implementations:
> http://developer.osdl.org/dev/fumount/


the problem with the people who say they want forced umount is.. that
most of the time they either want
1) get rid of the namespace entry
or
2) want to stop any and all IO to a certain device/partition 

1) is already supported with lazy umount (umount -l)
for 2), it's not forced umount that they want, it's really an IO
disconnect (which scsi supports btw in 2.6 kernels).

So.. depending on which of the 2 you are, it's there. Just it's not
called "forced umount".....


