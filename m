Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbXGEUA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbXGEUA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXGEUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:00:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:44237 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXGEUAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,505,1175497200"; 
   d="scan'208";a="103316378"
Message-ID: <468D4D82.8030009@linux.intel.com>
Date: Thu, 05 Jul 2007 12:58:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Liunx power consumption on laptops -- Enormous progress in the last
 few months
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with all the tickless and other goodies going into the kernel in the 
last few months, there is a lot of hope that this helps Linux reduce 
power consumption... and the good news is that it does... once you fix 
some bugs and fix a bunch of userspace applications.

While it's hard to show "one size fits all" number/percentage, we took 
a bog standard Lenovo T61 laptop (no vendor preference, they just were 
the first one to deliver a model with the latest Intel chipset to our 
cubes) and measured the effect. The baseline we used was a 32 bit 
Fedora 7 installation; note that this already has the tickless kernel, 
but is lacking several of the key bugfixes that came afterwards.

We've put our measurements in a graph at

http://ww.linuxpowertop.org/results.php

With kernel fixes and features, the power consumption of this laptop 
went from 21.06 Watts to 18.25 Watts; with 2 additional userspace 
fixes the power consumption ended up at 15.5 Watts.

(Don't worry that this is the end of it; there's more stuff in the 
various project pipelines, and we'll keep measuring the progress over 
time)


All in all, personally I'm very happy to see Linux making such a huge 
step forward with tickless and can't wait for this step to be 
available in all distros and for all architectures...

Greetings,
    Arjan van de Ven
