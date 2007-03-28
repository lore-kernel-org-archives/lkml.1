Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXC1GT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXC1GT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXC1GT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:19:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42353 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbXC1GT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:19:56 -0400
Message-ID: <460A0909.8000607@garzik.org>
Date: Wed, 28 Mar 2007 02:19:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jareguero@telefonica.net, atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH] atl1: remove unnecessary crc inversion
References: <20070328004349.GA2792@osprey.hogchain.net>
In-Reply-To: <20070328004349.GA2792@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> The original vendor driver contained a private ether_crc_le() function
> that produced an inverted crc.  When we changed to the kernel version of
> ether_crc_le(), we neglected to undo the inversion.  Let's do it now.
> Discovered by and patch proffered by Jose Alberto Reguero.
> 
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>

applied to #upstream-fixes


