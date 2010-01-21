Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0AUBAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0AUBAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240Ab0AUBAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:00:30 -0500
Received: from toro.web-alm.net ([62.245.132.31]:36000 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab0AUBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:00:30 -0500
Message-ID: <4B57A540.3010207@osadl.org>
Date: Thu, 21 Jan 2010 01:52:16 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathias Weber <mathias.weber.mw1@roche.com>
Subject: Re: [patch 0/3] sched: Make Priority Inheritance POSIX compliant
References: <20100120171231.922420383@linutronix.de>
In-Reply-To: <20100120171231.922420383@linutronix.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 09:58 PM, Thomas Gleixner wrote:
> The current PI implementation violates POSIX scheduling semantics when
> a thread is deboosted. The following patch series addresses this.

I can confirm that this patch series fixes the incorrect scheduling
behavior as observed in our test case.

Thanks, Thomas!

Tested-by: Carsten Emde <cbe@osadl.org>
