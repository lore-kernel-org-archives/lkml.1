Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbYLIFsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbYLIFsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 00:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYLIFsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 00:48:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54683 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYLIFsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 00:48:07 -0500
Message-ID: <493E0689.6020302@garzik.org>
Date: Tue, 09 Dec 2008 00:47:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Subject: Re: [PATCH 1/1] ATA: piix, fix pointer deref on suspend
References: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hi,
> 
> I've found this issue in the mmotm 2008-12-02-17-08.
> 
> --
> 
> Commit
> ata_piix: add borked Tecra M4 to broken suspend list
> introduced DMI variables checking, but they can be null, so that
> we possibly dereference null.
> 
> Check if they are null and avoid checks in that case.
> 
> Solves:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff8043da97>] piix_pci_device_suspend+0x117/0x230
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/ata/ata_piix.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)

applied #upstream-fixes (until someone creates a better patch...)


