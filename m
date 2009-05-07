Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZEGOYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZEGOYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZEGOYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:24:39 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42093 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbZEGOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:24:38 -0400
Date: Thu, 7 May 2009 10:13:52 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Alok Kataria <akataria@vmware.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <1241560625.8665.17.camel@alok-dev1>
Message-ID: <alpine.DEB.1.10.0905071010170.24528@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we need to reduce the general tick frequency to be as low as
possible. With high resolution timers the tick frequency is just the
frequency with which the timer interrupt disturbs a running application.

Are there any benefits remaining from frequent timer interrupts? I would
think that 60 HZ would be sufficient.

It would be good if the kernel would be truly tickless. Scheduler events
would be driven by the scheduling intervals and not the invokations of the
scheduler softirq.

