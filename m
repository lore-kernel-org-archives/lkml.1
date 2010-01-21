Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284Ab0AUL0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0AUL0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193Ab0AUL0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:26:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:48973 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0AUL0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZtVgKZaERZFrZFRFCPclbNc1c6NV+vnnpYA+t4+DaE93WKJ1a+7Alb13YfP4DV364W
         Ym7azgGaiwiSo23YDLjW+h74KrUOSnuiXd9/HxXF2FQQl5t5Ok6JwrvGoa+sb02TC9Oz
         Ym96YSotuctRI6MjVaf1bRETWvG0w2g7fj+GM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 05/64] pata_atiixp: remove superfluous wrapper function
Date: Thu, 21 Jan 2010 12:23:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <4B57D2E4.30203@garzik.org> <4B57D365.3040201@garzik.org>
In-Reply-To: <4B57D365.3040201@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001211223.16924.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 January 2010 05:09:09 am Jeff Garzik wrote:
> On 01/20/2010 11:07 PM, Jeff Garzik wrote:
> > On 01/18/2010 12:14 PM, Bartlomiej Zolnierkiewicz wrote:
> >> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >> Subject: [PATCH] pata_atiixp: remove superfluous wrapper function
> >>
> >> Fix documentation for ->set_[pio,dma]mode methods while at it.
> >>
> >> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> >> ---
> >> drivers/ata/pata_atiixp.c | 29 +++++++----------------------
> >> 1 file changed, 7 insertions(+), 22 deletions(-)
> >
> > applied
> 
> undone...  it broke the build, presumably because it requires something 
> in your tree that's not in libata-dev.git

Jeff, as noted in the first mail those patches are against atang tree
(which has many changes which are missing from your libata-dev tree)..

--
Bartlomiej Zolnierkiewicz
