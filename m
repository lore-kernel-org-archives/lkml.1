Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbZL0BHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbZL0BHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 20:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZL0BHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 20:07:51 -0500
Received: from mail.perches.com ([173.55.12.10]:1436 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbZL0BHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 20:07:50 -0500
Subject: Re: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for
 printks
From: Joe Perches <joe@perches.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091227002935.GC26593@khazad-dum.debian.net>
References: <1261797801.2568.69.camel@Joe-Laptop.home>
	 <20091226042017.GA14921@khazad-dum.debian.net>
	 <1261802563.2568.75.camel@Joe-Laptop.home>
	 <20091227002935.GC26593@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Dec 2009 17:07:49 -0800
Message-ID: <1261876069.2568.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-26 at 22:29 -0200, Henrique de Moraes Holschuh wrote:
> Unfolding the printk messages to a single line _is_ useful for grep, though,
> and I plan to do just that (not high priority, though), and I would accept
> patches that do just that without any fuss :)

perl -i -e 'local $/; while (<>) { s@\b(printk[^;]+)\"\s*\n\s*\"@$1@g ; print ; }' $file


