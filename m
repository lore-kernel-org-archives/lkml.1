Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYITLHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYITLHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYITLGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:06:55 -0400
Received: from server.drzeus.cx ([85.8.24.28]:50905 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbYITLGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:06:55 -0400
Date: Sat, 20 Sep 2008 13:06:52 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20080920130652.05f3da6d@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809150224o600fd9fhb29e986bdb618464@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	<5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	<20080909094438.6423b8ef@mjolnir.drzeus.cx>
	<5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	<20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	<5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
	<5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
	<20080914154817.3d618e67@mjolnir.drzeus.cx>
	<5ff4a1e50809150103v1e250e0x4192e2fe901750a6@mail.gmail.com>
	<20080915103821.2b618bba@mjolnir.drzeus.cx>
	<5ff4a1e50809150224o600fd9fhb29e986bdb618464@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 10:24:22 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> 
> OK, I can see your point here. However, this is a completely different
> change to my original patch. Would it not make more sense to queue my
> original patch and then for me to write some patches to move all the
> timeout info into the request structure?
> 

It's better to get it right directly. I'd consider this a bug fix
patch, so it can be applied at any time during the development cycle.

> 
> So, what I propose is this. Could you please queue my bug fix (I can
> send the two patches again) and then I will begin working on the
> generic patches to fix the issues that you've raised in this thread?
> How does that sound?

It shouldn't take that long to write the more proper solution, so get
to it and it should be possible to get in even for .27.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
