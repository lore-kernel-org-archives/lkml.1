Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYIIHp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYIIHp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYIIHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:44:41 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37704 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756647AbYIIHok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:44:40 -0400
Date: Tue, 9 Sep 2008 09:44:38 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20080909094438.6423b8ef@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	<20080907123832.5ba79c12@mjolnir.drzeus.cx>
	<5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	<20080909092216.46a6eba1@mjolnir.drzeus.cx>
	<5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 08:34:27 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> 2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> > On Mon, 8 Sep 2008 14:28:00 +0100
> > "Matt Fleming" <mattjfleming@googlemail.com> wrote:
> >
> >> You're right, I changed the patch accordingly (I also fixed the read
> >> timeout path).
> >>
> >
> > This still doesn't use the fields from the request structure. E.g. SDIO
> > support is probably still broken here as it mandates a timeout of 1
> > second for data transfers.
> >
> 
> What fields in the request structure? Are you talking about struct mmc_request ?

Yup, timeout_ns and timeout_clks.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
