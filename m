Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZL0A3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZL0A3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 19:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZL0A3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 19:29:39 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40466 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbZL0A3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 19:29:38 -0500
X-Sasl-enc: VwmMCHhFxSfLrEocPlWynpr6bP71sg4u3QYxm7VOP+Nw 1261873777
Date: Sat, 26 Dec 2009 22:29:35 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for
 printks
Message-ID: <20091227002935.GC26593@khazad-dum.debian.net>
References: <1261797801.2568.69.camel@Joe-Laptop.home>
 <20091226042017.GA14921@khazad-dum.debian.net>
 <1261802563.2568.75.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261802563.2568.75.camel@Joe-Laptop.home>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009, Joe Perches wrote:
> On Sat, 2009-12-26 at 02:20 -0200, Henrique de Moraes Holschuh wrote:
> > Why would I want a parameter macro instead of a straightforward bunch of
> > #defines ?
> 
> To make grep a bit easier.

Is greping for KERN_<priority> common?

Unfolding the printk messages to a single line _is_ useful for grep, though,
and I plan to do just that (not high priority, though), and I would accept
patches that do just that without any fuss :)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
