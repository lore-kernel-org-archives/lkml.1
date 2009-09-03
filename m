Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbZICHi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbZICHi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZICHi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:38:26 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:27816
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752096AbZICHiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:38:25 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz103dKa594izz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KPDX7V-01-0ZW-02
X-M-MSG: 
Date: Thu, 3 Sep 2009 09:38:18 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: urgent fixes for AMD Magny-Cours support
Message-ID: <20090903073818.GE7216@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Sep 2009 07:38:19.0260 (UTC) FILETIME=[81B213C0:01CA2C69]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so finally I've created a basic set of patches to fix Linux for AMD
Magny-Cours CPU. Basic means no new sysfs attributes, no new cpumasks
etc.  Most of it is AMD specific code. Only patch 4 modifies a more
generic x86 function.

I kindly ask to apply these patches for .31 -- even so late in the
game. It should not introduce regressions but allows to run .31 on
Magny-Cours without hiccups.

If it is really too late for .31 it should be scheduled for .32 and I'll try
to bring it into stable-31.


Thanks!

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


