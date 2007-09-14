Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXINNw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXINNw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXINNwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:52:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXINNwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:52:50 -0400
Date: Fri, 14 Sep 2007 09:52:37 -0400
From: Alan Cox <alan@redhat.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Steven Toth <stoth@hauppauge.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070914135237.GB19311@devserv.devel.redhat.com>
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota> <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com> <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com> <20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 01:17:05AM +0200, Markus Rechberger wrote:
> what stops vendors of using the current existing code to achieve that
> goal. They could provide binary drivers with the existing API.

If you feel lucky about the GPL

> What stops companies to intercept the ioctl calls and overriding some
> I2C commands?

The GPL - derivative work is the boundary not code linkage. Possibly a userspace
tuner hack would probably fit this too. Especially if a specific vendor is
producing both bits together and trying to claim they are independant.

> How about proprietary video formats, would you also place the decoding
> algorithms in kernel  just to force companies to release their code
> for it?

No, I would assume they'd provide a proprietary conversion library that
no nobody would use (just like their hw). We keep format conversion firmly
seperated from hardware I/O processing. 

Alan

