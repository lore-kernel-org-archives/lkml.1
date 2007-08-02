Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbXHBRAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbXHBRAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbXHBQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:59:35 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:21105 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbXHBQ7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l3cffxEYj1mpk8yYDIHg3+4KkjRhaOTA20OlQDM3Iib7met37S8JhVrXrRZLG5Y7iL/B9eJ3ElKl0mcDAMF+gO+ernH8qQMMxObw01wOxZ/CyaZncz8rwOpsZRA2caruYhtgzQEeMjj+QhcRNhQe8ouYAnNqZTZIqFFMSR2wvEc=
Message-ID: <46B20D6B.1060506@gmail.com>
Date: Fri, 03 Aug 2007 01:59:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH8 CF timeout (regression)...
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>
In-Reply-To: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> I'll grab kernel logs from the legacy ATA boot; what else can help
> debug this issue? No problem testing patches too.

Yeap, please post the old log.

> --- [2]
> ata2.00: limiting speed to UDMA/33:PIO4
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata2: soft resetting port
> ata2.00: configured for UDMA/33
> ata2: EH complete

What happens after this?

-- 
tejun
