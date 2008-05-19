Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYESIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYESIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYESIwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:52:10 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:57442 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbYESIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:52:08 -0400
Date: Mon, 19 May 2008 12:51:50 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080519105150.GB4557@ics.muni.cz>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.OcB.itBMIB@albercik> <200805191002.43734.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805191002.43734.oliver@neukum.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 19 May 2008 10:51:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:02:43AM +0200, Oliver Neukum wrote:
> Can you compile with USB_DEBUG and attach the "register" file from
> /sys/modules/ehci_hcd to see whether an interrupt is pending?

# gzip -dc /proc/config.gz | grep DEBUG | grep USB
CONFIG_USB_DEBUG=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_SERIAL_DEBUG is not set

which one is the file you want?

ls -F /sys/module/ehci_hcd/
drivers/  holders/  initstate  notes/  parameters/  refcnt  sections/

-- 
Luká¹ Hejtmánek
