Return-Path: <linux-kernel-owner+w=401wt.eu-S1423177AbXD3MHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423177AbXD3MHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423182AbXD3MHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:07:54 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:63420 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423177AbXD3MHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BvhbPRw9V+O1fMxNlnDKZxGadU4A48Odm2eFiztVUvlIzRE06iM3PIjPxzH/VPikzs7IRgJcQRCIZA7VR5NMRlKRTARXgBPhRkVkGUwEgNsseg4XVD2yIqqjdRmHckfwXLJtOjZ9fF5VsZRTW0T7mBb7GwaaMrDL1rtG97SKQOM=
Message-ID: <4635DC15.6090705@gmail.com>
Date: Mon, 30 Apr 2007 06:07:49 -0600
From: "Berck E. Nash" <flyboy@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com> <20070425011654.222a2b4b.akpm@linux-foundation.org> <462F1481.8010807@gmail.com> <20070425085432.GD17130@htj.dyndns.org> <20070425093044.GE17130@htj.dyndns.org> <462FE982.7030906@gmail.com> <46354620.4060902@gmail.com>
In-Reply-To: <46354620.4060902@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

> Hmmm... Once properly initialized, ahci is highly unlikely to cause
> runaway IRQs which results in nobody cared.  It has proper IRQ mask and
> pending bits allowing the driver to reliably detect when and why the
> controller is raising interrupt and disable it if necessary.  Can you
> try without the NVIDIA module?

I'm beginning to think it was a one-time hardware error of some sort.
I've been running 2.6.21-rc7-mm2 for awhile now and the problem hasn't
reoccurred, so I think you can consider the matter settled...

Thanks,
Berck
