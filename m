Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYAFFEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYAFFEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 00:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYAFFDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 00:03:53 -0500
Received: from [212.12.190.170] ([212.12.190.170]:45365 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750728AbYAFFDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 00:03:52 -0500
From: Al Boldi <a1426z@gawab.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Forcing modes in libata (was: SATA buffered read VERY slow)
Date: Sun, 6 Jan 2008 08:03:31 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200801051641.03927.a1426z@gawab.com> <20080105163016.608b1e7f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080105163016.608b1e7f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801060803.31939.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > What's hindering the ability to force a mode in libata, as is possible
> > with the normal ide-driver?
>
> We want it to be correct and race free. That means we have to synchronize
> all the devices on the controller, quiesce them and recompute the speeds
> for each device then turn them all back on and resume command processing.
>
> It is quite hairy although Tejun's EH work has provided the framework for
> all of this.
>
> For now you can boot with libata.dma=1 to select DMA on disks but not CD

Great, but why isn't this in the documentation?


Thanks!

--
Al

