Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZHJAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZHJAna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZHJAn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:43:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:13026 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZHJAn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:43:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,350,1246863600"; 
   d="scan'208";a="539887576"
From: "Tan, Wei Chong" <wei.chong.tan@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 10 Aug 2009 08:42:07 +0800
Subject: RE: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Topic: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Index: AcoVo8oOYb8qlSY+RyKW1k8jaGtXcADrujcg
Message-ID: <B28277FD4E0F9247A3D55704C440A140D5D683F3@pgsmsx504.gar.corp.intel.com>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
 <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
 <20090731195705.GA12270@elte.hu>
 <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com>
 <20090805080647.GC30307@elte.hu>
In-Reply-To: <20090805080647.GC30307@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi,
>>
>> We are performing some test on the patch and will keep everyone
>> posted with the progress soon.
>
>Thanks. I've zapped the original patch from x86/urgent. Linus's
>patch certainly looks feasible for .31 if it solves the problem and
>if we can merge it in the next few days.
>
>	Ingo

Hi,

Linus's patch looks good to go.  I've tested it with 2 separate versions of BIOS, each 1000 cycles, without any wrong CPU frequency being reported.  In contrast, the same CPU/platform without the patch will almost consistently report a wrong CPU frequency once every 20 cycles and once every 50 cycles respectively, for the 2 above mentioned BIOS.

Regards,
Tan Wei Chong.
