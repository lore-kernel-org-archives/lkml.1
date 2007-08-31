Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXHaUMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXHaUMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXHaUME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:12:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:4747 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbXHaUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GuUMmHvt6hKhhVa0jGxjw3xbxrxpQmcB7Q4OXUUvG1OJBomT9upmouB7HNHy2jWfcGeUkj6DX6XiUW1Yh0W8cUGAb4XsPpTmcsFPoSulAW+P5BM3NbY3nOnlxlDTbuYwoQOZitjH7ZyhePxBoqsYKMK76jSbGOyfiRsOPV0fzYI=
Message-ID: <8bd0f97a0708311312n78f1c163o20aa17214bfe3702@mail.gmail.com>
Date: Fri, 31 Aug 2007 15:12:00 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: [PATCH] Patch pvr2 driver to allow development of maple bus driver
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <8b67d60708311306v344e8f00w36dc244fc39df39f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com>
	 <8b67d60708311306v344e8f00w36dc244fc39df39f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/07, Adrian McMenamin <lkmladrian@gmail.com> wrote:
> This patch makes the PVR2 VBLANK interrupt on the SEGA Dreamcast
> shareable - a small but necessary change to enable ongoing efforts to
> develop a driver for the maple bus on the Dreamcast. (Maple is Sega's
> proprietary serial interface for the Dreamcast and can be set to
> synchronise dma transfers to the VBLANK).
>
> This has no impact on the performance of the PVR2.

sharable implies the interrupt handler checks to see if it actually
caused the interrupt ... which it doesnt at the moment ... presumably,
you're making it shared because another device will be using that
interrupt as well ... so when that other device gets an interrupt, how
do you know it's for that device and not PVR2 ?
-mike
