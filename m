Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYBECHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYBECHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYBECHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:07:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:45233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYBECHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LSMj2L+CJ3HEv2npgP08NT/rOuO6BxVI2oH+Hix01PSskD42KyxyqovOGQTgTQ2NyDoxuGvEB/mx4Y8Wx3P8Efzb+ARSu0aG7SeC0SCgZ9f7uh0gl78qTU3gnLxFPx4brjEdd/Weu/I4R/CmuQYNVQAHIgvfrxMlkBAGjx7u/yI=
Message-ID: <165ac690802041807r147531d8s6bb5f3a1f254bcbb@mail.gmail.com>
Date: Mon, 4 Feb 2008 20:07:01 -0600
From: "Chris Weiss" <cweiss@gmail.com>
To: dougg@torque.net
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       scst-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47A74BAA.6080201@torque.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A74BAA.6080201@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 11:30 AM, Douglas Gilbert <dougg@torque.net> wrote:
> Alan Cox wrote:
> >> better. So for example, I personally suspect that ATA-over-ethernet is way
> >> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and
> >> low-level, and against those crazy SCSI people to begin with.
> >
> > Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> > would probably trash iSCSI for latency if nothing else.
>
> And a variant that doesn't do ATA or IP:
> http://www.fcoe.com/
>

however, and interestingly enough, the open-fcoe software target
depends on scst (for now anyway)
