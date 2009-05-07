Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZEGPbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZEGPbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZEGPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:30:58 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47831 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751636AbZEGPa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:30:57 -0400
Date: Thu, 7 May 2009 11:20:06 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0905071117180.10171@qirst.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Alan Cox wrote:

> The tick also still appears to be involved in ntp and in cpu stats where
> a 50Hz tick would mean only 25Hz accuracy on CPU usage etc

That could be fixed. If a thread is running then its using the processor
and that does not change as long as it runs. That alone is enough to
calculate cpu usage.

Only if we want to examine the cpu state periodically while its running
(profiling) then we would have a justification for interrupting the
thread.
