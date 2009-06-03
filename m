Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZFCI4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZFCI4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZFCIzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:55:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52363 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753783AbZFCIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:55:46 -0400
Date: Wed, 3 Jun 2009 09:53:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
Message-ID: <20090603095346.64c874b1@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
	<1243926700-30485-4-git-send-email-vapier@gentoo.org>
	<20090602100018.415b1dfc@lxorguk.ukuu.org.uk>
	<8bd0f97a0906030103i64bc1a9duc5aeaea7bd3f8365@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This should have no effect on a modern kernel.
> 
> well, we wouldnt be making changes if we werent seeing data overruns today

If it has an effect then something else is going on.
> 
> > There is 64K of queueing between you and the ldisc nowdays.
> 
> i dont think that really matters ... we do too much work in the
> interrupt and so we miss new data

Which the other patches addressed so my guess is the real fixes were the
other changes.

Alan
