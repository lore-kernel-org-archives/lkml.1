Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbXGQWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbXGQWRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbXGQWRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:17:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50197 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXGQWRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:17:24 -0400
Message-ID: <469D3FF0.2010109@garzik.org>
Date: Tue, 17 Jul 2007 18:17:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by warnings
References: <20070717214239.GF28448@devserv.devel.redhat.com> <ada8x9epuip.fsf@cisco.com> <469D3E66.3010502@garzik.org>
In-Reply-To: <469D3E66.3010502@garzik.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> I don't buy that performance argument, in this case.  You are already 
> dirtying the same cacheline with other variable initializations.

Or simply sitting in a CPU register for large stretches of function 
runtime...

	Jeff


