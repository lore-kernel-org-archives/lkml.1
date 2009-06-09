Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbZFIQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbZFIQxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZFIQxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:53:23 -0400
Received: from www.tglx.de ([62.245.132.106]:44028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZFIQxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:53:22 -0400
Date: Tue, 9 Jun 2009 18:53:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "Tang, Feng" <feng.tang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <43F901BD926A4E43B106BF17856F075563408766@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0906091841430.3351@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop> <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain> <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop> <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain> <20090608141250.6a5735fa@feng-desktop> <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain> <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain> <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com> <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain> <43F901BD926A4E43B106BF17856F07556340868E@orsmsx508.amr.corp.intel.com>
 <alpine.LFD.2.00.0906091014110.3351@localhost.localdomain> <43F901BD926A4E43B106BF17856F075563408766@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Pan, Jacob jun wrote:

> Thanks for the explanations, I will add the secondary clock code to the
>  x86_quirks. It should be submitted for review soon.

Please take the patch I sent in the thread and make use of it in your
platform support. You just need set your function pointer in
x86_quirks->setup_secondary_clock when you detect on which platform
you are running.

Thanks,

	tglx
