Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbXIKSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbXIKSlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759800AbXIKSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:41:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbXIKSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:41:06 -0400
Date: Tue, 11 Sep 2007 20:40:22 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-ID: <20070911204022.108895d5@laptopd505.fenrus.org>
In-Reply-To: <20070911112531.80bac380.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111323.56030.rjw@sisk.pl>
	<20070911042228.1ef690e0.akpm@linux-foundation.org>
	<200709111409.13796.rjw@sisk.pl>
	<20070911112531.80bac380.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 11:25:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> dmesg without the cpuidle patch:
> http://userweb.kernel.org/~akpm/dmesg-bad.txt dmesg with the cpuidle
> patch: http://userweb.kernel.org/~akpm/dmesg-good.txt difference:
> http://userweb.kernel.org/~akpm/dmesg-diff.txt
> 
> there doesn't seem to be a lot of difference in the time handling,
> except there are large changes in when things happen in the bootup
> sequence.

powertop can show you which C-states are actually used; it could be a
theory that in the working case the deeper C-states aren't used (which
then means lapic keeps working etc)...
powertop would show this change ....
