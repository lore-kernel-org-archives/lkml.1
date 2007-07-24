Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbXGXUhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbXGXUhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXGXUhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:37:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59016 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbXGXUhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:37:35 -0400
Message-ID: <46A66305.9090904@garzik.org>
Date: Tue, 24 Jul 2007 16:37:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: jes@trained-monkey.org, linux-acenic@sunsite.dk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/acenic.c: fix check-after-use
References: <20070723080232.GF26212@stusta.de>
In-Reply-To: <20070723080232.GF26212@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> The Coverity checker noted that we've already dereferenced "dev" when we 
> check whether it's NULL.
> 
> Since it's impossible that "dev" is NULL at this place this patch 
> removes the NULL check.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


