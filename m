Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZC0Jgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZC0Jgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758967AbZC0Jg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:36:28 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42671 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbZC0Jg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:36:26 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net A39E51B3E20
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] config: Make need for SCSI_CDROM clearer
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 27 Mar 2009 10:36:22 +0100
References: <ck4Qt-44e-51@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Ln8UB-0001SM-50@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Mention ATAPI. We could insert an essay about libata and ide-scsi etc but
> the failure case is someone enables it which is just fine so keep it
> simple.

What about:

> +++ b/drivers/scsi/Kconfig
> @@ -121,7 +121,7 @@ config BLK_DEV_SR
>  tristate "SCSI CDROM support"

"CDROM support (except for old IDE and legacy drivers)"?

