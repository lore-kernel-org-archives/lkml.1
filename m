Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZGTC41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZGTC41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 22:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZGTC40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 22:56:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:56904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZGTC4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 22:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,231,1246863600"; 
   d="scan'208";a="534205941"
From: "Lu, Guanqun" <guanqun.lu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "jeremy@goop.org" <jeremy@goop.org>
Date: Mon, 20 Jul 2009 10:55:28 +0800
Subject: RE: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
Thread-Topic: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
Thread-Index: AcoG6WWYaG2Ro2lKSCuHLaGFL6WJLwB+9zsA
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7701E6F48AF7@PDSMSX501.ccr.corp.intel.com>
References: <1247834204-3084-1-git-send-email-guanqun.lu@intel.com>
 <200907170352.11749.rjw@sisk.pl>
 <alpine.LFD.2.00.0907171615530.11571@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907171615530.11571@localhost.localdomain>
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

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Friday, July 17, 2009 10:18 PM
>To: Rafael J. Wysocki
>Cc: Lu, Guanqun; linux-kernel@vger.kernel.org; mingo@elte.hu; jeremy@goop.org
>Subject: Re: [PATCH 1/3] add flag IRQF_NO_SUSPEND in 'struct irqaction'
>
>On Fri, 17 Jul 2009, Rafael J. Wysocki wrote:
>
>> On Friday 17 July 2009, Guanqun Lu wrote:
>> > We currently only bypass IRQF_TIMER in '__disable_irq',
>> > but Xen specific IRQs should not be disabled either.
>> > This commit adds a new flag to accompolish this goal
>> > without being mixed up with IRQF_TIMER flag.
>>
>> For some obscure reasons [2/3] didn't reach my inbox.  The other 2 patches
>> look fine to me.
>
>I do not receive the patches at all. Can you please resend and cc me ?

Resent now, let me know it doesn't get to your inbox again.

Guanqun

>
>Thanks,
>
>	tglx
