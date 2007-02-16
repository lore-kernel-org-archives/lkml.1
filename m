Return-Path: <linux-kernel-owner+w=401wt.eu-S1423478AbXBPJc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423478AbXBPJc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423481AbXBPJc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:32:58 -0500
Received: from ns.firmix.at ([62.141.48.66]:42505 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423478AbXBPJc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:32:58 -0500
Subject: RE: kernel porting query
From: Bernd Petrovitsch <bernd@firmix.at>
To: "Ajay Singh (ajaysi)" <ajaysi@cisco.com>
Cc: Rick Brown <rick.brown.3@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       linux-newbie@vger.kernel.org
In-Reply-To: <677342AB6AE12D4DB59A9D473F40D74B028E0411@xmb-blr-416.apac.cisco.com>
References: <7783925d0702151816r7df63816ld9c69b56bdb0a0b9@mail.gmail.com>
	 <677342AB6AE12D4DB59A9D473F40D74B028E0411@xmb-blr-416.apac.cisco.com>
Content-Type: text/plain
Organization: Firmix software GmbH
Date: Fri, 16 Feb 2007 10:32:42 +0100
Message-Id: <1171618362.23981.10.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.417 required=5
X-Spam-Score: -2.417 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 07:46 +0530, Rick Brown wrote:

Your quoting style sucks. I fixed it by hand.
 
[...]
> > 1) Can any one please shed some light on precisely and exactly what are
> > differences in different boards for which we need to port linux?

> On Fri, 2007-02-16 at 09:48 +0530, Ajay Singh (ajaysi) wrote:
> The differences depends on the boards ... Mostly if they belong to the
> same family the differences could be mainly in the peripherials ...
> Interrupt mappings... Serial interface ... Memory sizes (if differnet
> boards have different memory sizes) ... Sometimes some devices may be
> moved to some other locations in the memory map (Look at memory map of
> your SoC on your board). 

You may have different boot loaders (or none at all).
You also may have different storage media like FlashRAM, IDE,
network, .... for boot loader/kernel/root filesystem. They may have
different sizes and it makes a "little" difference for your requirements
in the toolchain if you have 4MB or 1GB to boot your system from.

All that kind of information can be found in a BSP (board support
package).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

