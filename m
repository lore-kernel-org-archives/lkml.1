Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbZEGUdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbZEGUdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762436AbZEGUcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:32:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38584 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760689AbZEGUcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:32:53 -0400
Date: Thu, 7 May 2009 21:30:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507213040.181e69c1@lxorguk.ukuu.org.uk>
In-Reply-To: <4A033EAB.8010700@garzik.org>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
	<20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
	<4A02FE91.8070006@zytor.com>
	<4A031269.3000603@garzik.org>
	<20090507180909.4b0a8672@lxorguk.ukuu.org.uk>
	<4A03209E.4070603@garzik.org>
	<20090507205101.0091eb2a@lxorguk.ukuu.org.uk>
	<4A033EAB.8010700@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would rather fix the API, than investigate hacky solutions that 
> complicate the code even more.

The fundamental problem is that the API that is wrong is "jiffies". The
false notion that there is some magical free timer variable.

