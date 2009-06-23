Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZFWHYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZFWHYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZFWHYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:24:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZFWHYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:24:15 -0400
Date: Tue, 23 Jun 2009 09:23:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 1/8] SFI: Simple Firmware Interface - new Linux
	sub-system
Message-ID: <20090623072351.GA6397@elte.hu>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> CONFIG_SFI=y enables the kernel to boot and run optimally
> on platforms that support the Simple Firmware Interface.
> 
> Thanks to Jacob Pan for prototyping the initial Linux SFI support,
> and to Feng Tang for Linux bring-up and debug in emulation
> and on hardware.
> 
> See http://simplefirmware.org for more information on SFI.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    5 +++++
>  MAINTAINERS                         |   12 ++++++++++++
>  arch/x86/Kconfig                    |    2 ++
>  drivers/sfi/Kconfig                 |   16 ++++++++++++++++
>  4 files changed, 35 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/sfi/Kconfig

Looks useful but this series needs review and acked-by from the x86 
maintainers, obviously. It touches a lot of x86 details.

	Ingo
