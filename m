Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKXIc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKXIc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYKXIcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:32:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:32696 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYKXIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kL0+V7R8asoTy/SO9dsM8v4v8PIS1oPH5snVVDYWnudH2tq0SoEfAWF2bm2i/gNyrH
         l5QpByKD69umXTXuJOdK1+XU+1JevEQMzRxvgmSwjWvMRH/uArRghMrNd6+OaJ9qiagX
         sSAXOVMhI2/AyDTlTpwRepsmvgjmK4Yf6Lfjw=
Subject: Re: [Bug #12038] Suspend regression in stable kernel 2.6.27.4 on
 Mac mini Core Duo
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Tino Keitel <tino.keitel@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20081124080334.GA4598@dose.home.local>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
	 <vyitTh0pP2N.A.nJC.c7HKJB@chimera>  <20081124080334.GA4598@dose.home.local>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 00:32:42 -0800
Message-Id: <1227515562.3108.30.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:03 +0100, Tino Keitel wrote:
> On Sat, Nov 22, 2008 at 21:28:19 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Hi,
> 
> 2.6.28-rc6 (or more precisely:
> ed313489badef16d700f5a3be50e8fd8f8294bc8) still hangs my Mac after
> resume, and git log drivers/acpi/sleep/main.c shows no relevant commits.
> 
> Regards,
> Tino
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I'm not getting a freeze here(was getting strange cpu frequencies
though); My setup here is the latest xserver from intrepid
readeon, and s2ram app. echo mem > /sys/power/state gives
me a black screen, then an instant reboot. s2ram recovers
as expected. Although I'm not sure what the setup is with macmini,
I've a macbook pro ati chipset.

regards;
-- 
Justin P. Mattock <justinmattock@gmail.com>

