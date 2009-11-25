Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZKYSXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZKYSXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbZKYSXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:23:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:59219 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZKYSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:23:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wilpgfJKlx577PSF8glXTR6ExfINmRsjzPc3d9aSZBkSP/FLFrefrBvWUxxHyVZZZu
         RhCDSybJfBeuJWpGdOF460mv8W+5tq7K2vGh71256kZJSysYG2WCqHiU8ola0oMFTQnI
         01H4vTxV/Kbuq03iPBqqFM8p7FWz0/evrWF6w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 48/86] pata_legacy: add pointers to QDI65x0 documentation
Date: Wed, 25 Nov 2009 19:21:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200911251844.59772.bzolnier@gmail.com> <20091125181253.14159347@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125181253.14159347@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251921.53754.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009 07:12:53 pm Alan Cox wrote:
> On Wed, 25 Nov 2009 18:44:59 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Wednesday 25 November 2009 06:38:52 pm Alan Cox wrote:
> > > > + *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
> > > > + *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
> > > > + *	Samuel Thibault <samuel.thibault@ens-lyon.org>
> > > 
> > > It's not drivers/ide/legacy/qd65xx.c - because you moved it back in the
> > > old IDE code.
> > 
> > It was the correct path/driver when the aforementioned code was added.
> 
> Sure but the path has changed so its more helpful for anyone looking back
> to have the right path.

I disagree.  The code from back then is not the same code as today and we
have git log --follow for this.

--
Bartlomiej Zolnierkiewicz
