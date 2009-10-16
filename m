Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZJPK0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZJPK0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZJPK0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:26:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44555 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbZJPK0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:26:49 -0400
Message-ID: <4AD84A43.2040203@garzik.org>
Date: Fri, 16 Oct 2009 06:26:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
References: <20091006150737.9610.81541.stgit@localhost.localdomain>
In-Reply-To: <20091006150737.9610.81541.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 11:07 AM, Alan Cox wrote:
> The SC1200 needs a NULL terminator or it may cause a crash on boot.
>
> Bug #14227
>
> Also correct a bogus comment as the driver had serializing added so can run
> dual port.
>
> Signed-off-by: Alan Cox<alan@linux.intel.com>
> ---
>
>   drivers/ata/pata_sc1200.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)

applied


