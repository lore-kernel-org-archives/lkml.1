Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593Ab0ASWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0ASWG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969Ab0ASWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:06:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:58076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0ASWG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:06:56 -0500
Message-ID: <4B562C64.7090303@kernel.org>
Date: Tue, 19 Jan 2010 14:04:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, irq: don't block IRQ0_VECTOR..IRQ15_VECTOR's on
 all cpu's
References: <1263932453.2814.52.camel@sbs-t61.sc.intel.com>	 <4B561D37.9040007@kernel.org> <1263936200.2814.55.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263936200.2814.55.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 01:23 PM, Suresh Siddha wrote:
> On Tue, 2010-01-19 at 12:59 -0800, Yinghai Lu wrote:
>> when PIC is used, if the user is setting /proc/irq/[0-15]/smp_affinity to cpu other than 0,
>> we need to prevent that happen.
> 
> If it is handled by i8259A_chip, then even today we won't be able to
> change smp_affinity because of no "set_affinity" for that irq_chip.

Then it is ok.

Thanks

Yinghai
