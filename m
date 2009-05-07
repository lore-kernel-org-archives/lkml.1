Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbZEGOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbZEGOVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZEGOVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:21:06 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:36972 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754005AbZEGOVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:21:05 -0400
Date: Thu, 7 May 2009 10:09:56 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: akataria@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <20090505233339.542880f8@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0905071004100.24528@qirst.com>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <20090505224417.0f00c2f0@lxorguk.ukuu.org.uk> <1241561394.8665.31.camel@alok-dev1> <20090505233339.542880f8@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Alan Cox wrote:

> HZ on a tickless system has no meaningful relationship to wakup rates -
> which are what I assume you actually care about.

Linux is not tickless. It only switches off ticks if a processor is idle.

> So do you want to change the precision of poll() and other
> functionality ? or do you want to change the wakeup rates and
> corresponding virtualisation overhead ?

select and poll use timeouts based on high resolution timers.

> What measurements have you done that make you think HZ is relevant in a
> tickless kernel ?

Just reading the code gets you there.


