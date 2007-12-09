Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXLIJJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXLIJJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 04:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXLIJJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 04:09:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:35074 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXLIJJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 04:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Fd60mrPMZx1LsB1Q389jE2ES1nxQDuvudwhaXDAwyAygbN+l9NHYheUe+K/am/5d10pAx0ha+cYV+E7RyGyLesSGn6ZU66Xrv7YVSVlC23SERRYVUm+DCqoo+OtjDDPpcCmBvaHwZnuNLywaiXLwFX2SdX1kVzEde1fpLenSn10=
Message-ID: <475BB0BD.8010306@gmail.com>
Date: Sun, 09 Dec 2007 10:09:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu>
In-Reply-To: <20071209074647.GE22981@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2007 08:46 AM, Ingo Molnar wrote:
> ah. If you comment out get_online_cpus()/put_online_cpus() from 
> kernel/softlockup.c, does it start working?

Yes indeed. (the process_64 part of the previous patch applied, but I think it
has no effect to this issue?)
