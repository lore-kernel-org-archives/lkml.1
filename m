Return-Path: <linux-kernel-owner+w=401wt.eu-S1423340AbXEEP6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423340AbXEEP6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423335AbXEEP6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:58:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34013 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423203AbXEEP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:58:20 -0400
X-Sasl-enc: ckrqbi2Up32oOiQVXa2QfzkfKR4Ab1w1eXR5ONpaUlBi 1178380699
Date: Sat, 5 May 2007 12:58:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Message-ID: <20070505155815.GC15620@khazad-dum.debian.net>
References: <1178314144.6094.7.camel@localhost.localdomain> <200705050118.34711.ak@suse.de> <1178321228.6094.34.camel@localhost.localdomain> <1178375214.31213.13.camel@localhost.localdomain> <1178375435.31213.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178375435.31213.16.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007, Thomas Gleixner wrote:
> +		printk(KERN_WARNING "HPET counter is defect\n");

What about
		printk(KERN_WARNING "HPET counter is stopped\n");

which is far more descriptive?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
