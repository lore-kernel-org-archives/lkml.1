Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXLaQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXLaQRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXLaQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:17:21 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:21968 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXLaQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:17:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZrRVqKWcFe5RiM+dRzqbaCs6Q3ZhmXYJ++uCholhPNosQcS6i44YXQ2o2jc3cgZN0NrBl6agEIJ2nxBPVrNKvo5xrbjQ07PpaCbC+cl8+BofnLochzv0jalh1XQNgCV32Ipx4Pd+XzOxFfeGQQeAIzQWhuMrqBg51dUsGWRXSWI=
Message-ID: <64bb37e0712310817g621d818dyebbf2228063d4d5f@mail.gmail.com>
Date: Mon, 31 Dec 2007 17:17:19 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Cc: "Michael Buesch" <mb@bu3sch.de>, "Adrian Bunk" <bunk@kernel.org>,
       "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20071231160140.579f0fb2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz>
	 <20071231144255.GB13803@does.not.exist>
	 <64bb37e0712310755k2446e67eq81d31cd476eb75e3@mail.gmail.com>
	 <200712311659.14847.mb@bu3sch.de>
	 <20071231160140.579f0fb2@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 31, 2007 5:01 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > I'd say the practical advantage to the user would be almost zero.
> > Which distribution is going to enable this option and defacto
> > banning external modules?
>
> It would be a real nuisance for developing code let alone for using it.

Hmm... Why?
a) this could be disabled during development if you want this
b) this would even only affect development if you add new code that
now needs a EXPORT_SYMBOL that was removed on an earlier build. And
right now this would also need to trigger a rerun of depmod. And the
same trigger could redo this garbage collect.

Or am I missing something obvious?

> The entries are currently far bigger than is needed and fixing that would
> be much more productive.

Can't say anything about that. ;)

Torsten
