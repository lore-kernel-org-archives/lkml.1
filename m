Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYC0Sa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYC0Sa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYC0SaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:30:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:47226 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754096AbYC0SaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:30:09 -0400
X-Authenticated: #1946754
X-Provags-ID: V01U2FsdGVkX19m7z4GmnpmX66L0P9lhRhldA62Un5aCeDECEQTSh
	sohO9i09AIg4hS
Message-ID: <47EBE7AE.5020402@gmx.de>
Date: Thu, 27 Mar 2008 19:30:06 +0100
From: Markus Rehbach <markus.rehbach@gmx.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer dereference
References: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de> <20080325233357.17d6ac41.akpm@linux-foundation.org> <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803271615470.3781@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
 > On Tue, 25 Mar 2008, Andrew Morton wrote:

 >> http://lkml.org/lkml/2008/3/21/202 and it's already in the regresison list.
 >
 > Same here. And both are AMD X2 early stepping machines.

 > A dropped workaround for the prefetch bug in early X2s and
 > Opterons. Patch below.

The patch cures it. Tested with rc5-git5, and it was 100%
reproducible here.

Markus
