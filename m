Return-Path: <linux-kernel-owner+w=401wt.eu-S965733AbXJQBPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965733AbXJQBPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXJQBPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:15:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47511 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXJQBPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:15:36 -0400
Message-ID: <47156231.1020600@garzik.org>
Date: Tue, 16 Oct 2007 21:15:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tokenring/3c359.c: fixed array index problem
References: <20071013081937.GA22759@suse.de>
In-Reply-To: <20071013081937.GA22759@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Meissner wrote:
> Hi,
> 
> I tried to send this to netdev and various maintainers, but
> they seem not to have seen it.
> 
> Please add to -mm and have it merged somewhere.
> 
> 
> The xl_laa array is just 6 bytes long, so we should substract
> 10 from the index, like is also done some lines above already.
> 
> Signed-Off-By: Marcus Meissner <meissner@suse.de>
> ---
>  drivers/net/tokenring/3c359.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied


