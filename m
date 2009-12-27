Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZL0BK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZL0BK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 20:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZL0BKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 20:10:25 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52182 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbZL0BKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 20:10:24 -0500
X-Sasl-enc: f+Ix9nckLb5wpLcKs7jnHaGlx8ibiGFdzzTlnC/ERVz8 1261876223
Date: Sat, 26 Dec 2009 23:10:21 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for
 printks
Message-ID: <20091227011021.GA27769@khazad-dum.debian.net>
References: <1261797801.2568.69.camel@Joe-Laptop.home>
 <20091226042017.GA14921@khazad-dum.debian.net>
 <1261802563.2568.75.camel@Joe-Laptop.home>
 <20091227002935.GC26593@khazad-dum.debian.net>
 <1261876069.2568.96.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261876069.2568.96.camel@Joe-Laptop.home>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Dec 2009, Joe Perches wrote:
> On Sat, 2009-12-26 at 22:29 -0200, Henrique de Moraes Holschuh wrote:
> > Unfolding the printk messages to a single line _is_ useful for grep, though,
> > and I plan to do just that (not high priority, though), and I would accept
> > patches that do just that without any fuss :)
> 
> perl -i -e 'local $/; while (<>) { s@\b(printk[^;]+)\"\s*\n\s*\"@$1@g ; print ; }' $file

Will try this one later.  Thanks.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
