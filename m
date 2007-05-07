Return-Path: <linux-kernel-owner+w=401wt.eu-S966735AbXEGVNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966735AbXEGVNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXEGVNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:13:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26975 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbXEGVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:13:29 -0400
Subject: Re: Need help debugging RT-preempt patch
From: Daniel Walker <dwalker@mvista.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       dirk.behme@googlemail.com, linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <463F93FB.1000908@am.sony.com>
References: <463F7449.2020509@am.sony.com>
	 <1178569719.3164.6.camel@imap.mvista.com>  <463F93FB.1000908@am.sony.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 14:11:39 -0700
Message-Id: <1178572299.3164.14.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 14:02 -0700, Tim Bird wrote:
> Daniel Walker wrote:
> > Are you sure you don't have HardIRQS in Threads enabled? Also are you
> > sure the kernel boots without the rt patch applied.
> 
> Yes on both counts.  I double-checked the configs.  I'm using quilt
> and the RT patch is at the end of my series, so it was easy to
> pop the patch and try again (module .config fixups).
> 
> I may take a few more blind stabs at different configs before
> I go diving into the networking code trying to trace something.
> (or before starting to bisect the patch).  Bisecting the patch
> will be a bit painful since it's currently an all-in-one.

I'm not sure I'd get into "bisecting" one big patch. Especially if you
new to the patches inner workings.. 

You can bisect by kernel version using the older patches but it's
clearly limited,

http://people.redhat.com/mingo/realtime-preempt/older/


Daniel

