Return-Path: <linux-kernel-owner+w=401wt.eu-S1762157AbZEGPNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157AbZEGPNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZEGPNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:13:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57390 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761451AbZEGPNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:13:20 -0400
Date: Thu, 7 May 2009 16:12:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: akataria@vmware.com, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507161232.6e33df34@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071004100.24528@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
	<1241561394.8665.31.camel@alok-dev1>
	<20090505233339.542880f8@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0905071004100.24528@qirst.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 10:09:56 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> On Tue, 5 May 2009, Alan Cox wrote:
> 
> > HZ on a tickless system has no meaningful relationship to wakup rates -
> > which are what I assume you actually care about.
> 
> Linux is not tickless. It only switches off ticks if a processor is idle.

Hooray - finally someone admits the *real* problem here, and for power
management too. Otherwise known as "referencing jiffies as a variable must
die"

Alan
