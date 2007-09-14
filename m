Return-Path: <linux-kernel-owner+w=401wt.eu-S1762664AbXINNCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664AbXINNCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbXINNCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:02:30 -0400
Received: from host81-155-195-211.range81-155.btcentralplus.com ([81.155.195.211]:59013
	"EHLO the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753725AbXINNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:02:29 -0400
X-Greylist: delayed 3531 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 09:02:29 EDT
Date: Fri, 14 Sep 2007 13:10:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Toth <stoth@hauppauge.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       Manu Abraham <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070914131003.71ba5ae4@the-village.bc.nu>
In-Reply-To: <46E99F36.8090809@hauppauge.com>
References: <46C1BCC5.9090709@amd.com>
	<1189626560.5160.57.camel@gaivota>
	<d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	<d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	<20070913131353.GB26972@linuxtv.org>
	<d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	<46E95C54.4060502@gmail.com>
	<d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	<46E99F36.8090809@hauppauge.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > * Why did someone duallicense videodev2 with BSD/GPL?

Originally the BSD people wanted to share the interface for user space
compatibility.

The kernel however is GPL so the BSD licence on some bits of the code
isn't really relevant as the combination of bits you depend upon is GPL,
will remain GPL and the only way to do a binary module would be to show
it is not in any way a derivative work in law.

> I know for certain that adding a userland API tuner/demod interface to 
> the kernel, allowing non-caring opportunistic silicon or board vendors 
> to developer closed source proprietary drivers, will have a negative 
> effect on the community and we'd set back linuxtv 3-5 years.

Agreed entirely

