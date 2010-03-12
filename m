Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0CLNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:50:33 -0500
Received: from borg.medozas.de ([188.40.89.202]:52578 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656Ab0CLNuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:50:32 -0500
Date: Fri, 12 Mar 2010 14:50:31 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Frans Pop <elendil@planet.nl>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tcpdump broke in 2.6.34-rc1
In-Reply-To: <201003121424.00868.elendil@planet.nl>
Message-ID: <alpine.LSU.2.01.1003121450050.14684@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003120037050.22042@obet.zrqbmnf.qr> <201003121424.00868.elendil@planet.nl>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2010-03-12 14:23, Frans Pop wrote:

>Jan Engelhardt wrote:
>> I am currently on 2.6.34-rc1 and found that tcpdump no
>> longer works (dies with setsockopt: invalid argument). Bisect-narrowed
>> it down to somewhere between
>
>Probably the same as http://lkml.org/lkml/2010/3/9/439, which has an exact 
>bisect.
>
>Has a follow-up that it's fixed by
>http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=1162563f82b434e3099c9e6c1bbdba846d792f0d

Thanks for looking it up. The patch does indeed fix the issue.
