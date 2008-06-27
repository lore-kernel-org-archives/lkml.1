Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYF0Fe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYF0Fe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYF0Fdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:33:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56727 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYF0Fdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:33:37 -0400
Message-ID: <48647BAA.8060308@pobox.com>
Date: Fri, 27 Jun 2008 01:33:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: florian.fainelli@telecomint.eu, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/r6040.c: Eliminate double sizeof
References: <Pine.LNX.4.64.0806232311570.13402@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0806232311570.13402@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Taking sizeof the result of sizeof is quite strange and does not seem to be
> what is wanted here.
> 
> This was fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> expression E;
> @@
> 
> - sizeof (
>   sizeof (E)
> - )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

applied


