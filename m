Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbXFUXCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbXFUXCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbXFUXCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:02:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:20400 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXFUXCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Rni9ioBxHATLOwUq7g3g73CyLo8uj6C6roFmFpYVEfGix9Rv+BryWvdGRu9ZLINeJpget76Q0ucnDIBPuZj1GRGbJHia8It3n69oq2kxPsRnZ3h+UAjQ0TgFPvhGD4VFbAriSIGZ2clYjRowJghwxrQ9+k4DiCIjrsecD4TTmEM=
Message-ID: <20f65d530706211602v67f410aaoec92030737505ab9@mail.gmail.com>
Date: Fri, 22 Jun 2007 11:02:19 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: iTCO_wdt stops CPU fan control
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

After many hours to testing, we found that the Hardware Watchdog Timer
module causes our motherboard's BIOS CPU fan control to stop
controlling the fan. On Linux bootup, the fan speed stays constant all
the time.

Setup:
- kernel 2.6.20.1 and 2.6.21.5
- iTCO_wdt loaded with ICH4 chip on motherboard

If watchdog module is excluded from the kernel build, fan control
works as normal.

Regards
Keith
