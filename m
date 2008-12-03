Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYLCJEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYLCJEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYLCJEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:04:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:43753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbYLCJEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:04:32 -0500
Message-ID: <49364B93.5000409@kernel.org>
Date: Wed, 03 Dec 2008 18:04:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Subject: Re: [PATCH 1/1] ATA: piix, fix pointer deref on suspend
References: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Dec 2008 09:03:49 +0000 (UTC)
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

Thanks.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
