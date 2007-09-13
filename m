Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbXIMPvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbXIMPvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXIMPuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:50:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:15925 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXIMPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=djBwSQ8BIVwj4SOv5wqZZ2agFyGBGCLwr4i3ecWfCR+frLkR2su1vebwOSBKBqSJVzdmKZnv3mfSh3C1o564bG6B0e2jLqbaP/FRAR6R4tO+Z9dRQu4bH2cO6eR43V3m5o3vQ4TxB6QvXFr9cH1yoxFzEYStn2e4csdjBtRIfF0=
Message-ID: <46E95C54.4060502@gmail.com>
Date: Thu, 13 Sep 2007 19:50:44 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       akpm@linux-foundation.org
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>	<d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>	<d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>	<20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
In-Reply-To: <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's only a step in development, I do not intend to keep the kernel
> stub in the end, but I do intend to keep and use the userspace drivers
> with i2c-dev in the long run, this requires a v4l/dvb library at the front
> of everything.

Well, this was what adq and myself did with libdvbapi and mti, (much
before UIO was announced at LK.) It is not tied to I2C either.

But, according to your statements (with regards to i2c-dev) you can
handle only some I2C based devices, which is in fact a subset of a
subset. Also not to forget that hardly a few I2C devices are in fact
"truly" I2C compatible. In fact many variables to be considered.

Also there is to consider a non technical aspect, whether vendors will
misuse this interface for binary only, undermining the efforts put in
for OSS drivers.

Manu
