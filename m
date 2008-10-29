Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYJ2KoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYJ2KoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYJ2Knm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:43:42 -0400
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:48738 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499AbYJ2Knk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:43:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Long delays and keystrokes required - related to disk encryption?
Date: Wed, 29 Oct 2008 11:43:33 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <200810281744.52587.elendil@planet.nl> <200810290153.23514.elendil@planet.nl> <4907D957.6040206@linux.intel.com>
In-Reply-To: <4907D957.6040206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291143.35041.elendil@planet.nl>
X-OriginalArrivalTime: 29 Oct 2008 10:43:37.0766 (UTC) FILETIME=[3332B460:01C939B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2008, Arjan van de Ven wrote:
> Frans Pop wrote:
> > On Tuesday 28 October 2008, Frans Pop wrote:
> >> During the boot there are several places where I need to hit a key
> >> for the boot to continue. There are also some very long delays
> >> before the next syslog message is displayed.
> >
> > I've bisected it to:
> > commit dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
> > Author: Arjan van de Ven <arjan@linux.intel.com>
> > Date:   Mon Oct 13 10:32:15 2008 -0400
> >     rangetimers: fix the bug reported by Ingo for real
>
> ok one easy thing to try, in the peek function (that this patch
> touches), just stick a "return" as first statement in.
> If that "fixes" it, we have a real issue with hrtimers, if not then
> something else is going on..

Confirmed here too: adding the "return" results in a good boot.

Cheers,
FJP
