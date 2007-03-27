Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXC0Onh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXC0Onh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbXC0Onh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:43:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbXC0Ong (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:43:36 -0400
Message-ID: <46092D38.3020508@redhat.com>
Date: Tue, 27 Mar 2007 10:42:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Chris Lalancette <clalance@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 2/2] percpu enable flag for softlockup watchdog
References: <20070327053816.881735237@goop.org> <20070327054106.809292985@goop.org>
In-Reply-To: <20070327054106.809292985@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> +static DEFINE_PER_CPU(int, enabled);
>   

Minor nit: let's call this softlockup_enabled.  Makes it easier for the 
reader ;)

P.
