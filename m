Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYIIIz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYIIIz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYIIIzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:55:18 -0400
Received: from server.drzeus.cx ([85.8.24.28]:46493 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753471AbYIIIzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:55:16 -0400
Date: Tue, 9 Sep 2008 10:55:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Matt Fleming" <mattjfleming@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Message-ID: <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
In-Reply-To: <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	<20080907123832.5ba79c12@mjolnir.drzeus.cx>
	<5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	<20080909092216.46a6eba1@mjolnir.drzeus.cx>
	<5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	<20080909094438.6423b8ef@mjolnir.drzeus.cx>
	<5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 08:59:11 +0100
"Matt Fleming" <mattjfleming@googlemail.com> wrote:

> 
> OK, just to be clear, where are those fields not used? They are used
> in the new mmc_get_timeout() function.
> 

Sorry, you're right. I just noticed the !host->mmc->card part and
assumed you had your own logic in there.

Why do you have that part though? What case have you found where you
need the timeouts and do not have properly set timeout fields?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
