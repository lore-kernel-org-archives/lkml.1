Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbYI3MCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbYI3MCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYI3MC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:02:27 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:43683 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYI3MC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lzi6pG88PPbmxWvkRhs2kG31qqCCcqwOuR/bILu4Eupj9rokFx8CXu65gKauvNQtI/
         2j14OATlbKFSR2EhJmRoio02p+w5gSu/r2hOopTIzFPnlbnTUzow8x/SEOERMnRwJl0+
         XfbzYHkPOecb0eNZ2NJVvEC1Rf+k1nzQMDlAM=
Message-ID: <c384c5ea0809300502h48915058r78a6586968c1ac1a@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:02:25 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] mtd: AT49BV6416 has swapped erase regions
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1222775733-6690-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222775733-6690-1-git-send-email-haavard.skinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard,

On Tue, Sep 30, 2008 at 1:55 PM, Haavard Skinnemoen
<haavard.skinnemoen@atmel.com> wrote:
> The CFI information read from AT49BV6416 lists the erase regions in the
> wrong order, causing problems when trying to erase or update the first
> or last 64K block.
>
Are there other Atmel designs with this bug or only the chip with this CFI ID?

I ask, because the check in u-boot is too generic; I found u-boot
wrongly assumes wrong order for another Atmel part, not checking on a
specific CFI ID.

(Need to lookup the part numbers later at home).

Regards,
-- 
Leon
