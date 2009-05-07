Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbZEGQ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbZEGQ4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760396AbZEGQ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:56:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35403 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZEGQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:56:23 -0400
Message-ID: <4A031269.3000603@garzik.org>
Date: Thu, 07 May 2009 12:55:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>	<1241560625.8665.17.camel@alok-dev1>	<alpine.DEB.1.10.0905071010170.24528@qirst.com> <20090507161440.5b9c067d@lxorguk.ukuu.org.uk> <4A02FE91.8070006@zytor.com>
In-Reply-To: <4A02FE91.8070006@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Alan Cox wrote:
>> Hooray - finally someone admits the *real* problem here, and for power
>> management too. Otherwise known as "referencing jiffies as a variable must
>> die"
> 
> Amen.  Also, "using HZ as a unit of measurement must die, too."

Love to -- now, what will it be replaced with?

grep for 'deadline' in drivers/ata/libata* to find an example not so 
easily converted away from jiffies.

	Jeff



