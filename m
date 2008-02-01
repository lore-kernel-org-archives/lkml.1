Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYBASxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYBASxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYBASxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:53:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYBASxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:53:07 -0500
Message-ID: <47A36A8D.90301@garzik.org>
Date: Fri, 01 Feb 2008 13:53:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 1/1] Net: e100, fix iomap mem accesses
References: <479F9E14.1070700@intel.com> <1201643356-28221-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1201643356-28221-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Patch against netdev-2.6 follows.
> --
> writeX functions are not permitted on iomap-ped space change to iowriteX,
> also pci_unmap pci_map-ped space on exit (instead of iounmap).
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/net/e100.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

applied


