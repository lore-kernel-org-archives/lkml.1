Return-Path: <linux-kernel-owner+w=401wt.eu-S1762008AbZFXUFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008AbZFXUFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762388AbZFXUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:05:09 -0400
Received: from fmailhost02.isp.att.net ([204.127.217.102]:54546 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762038AbZFXUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:05:08 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A4286F8.9020501@lwfinger.net>
Date: Wed, 24 Jun 2009 15:05:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net> <alpine.LFD.2.00.0906241715500.2767@localhost.localdomain> <1245859068.3216.5.camel@localhost.localdomain> <20090624161306.GC7239@us.ibm.com> <1245861219.3216.15.camel@localhost.localdomain> <20090624094411.08fc66e6@jbarnes-g45> <20090624175513.GE7239@us.ibm.com> <20090624112849.55b38fff@jbarnes-g45> <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain> <20090624194839.GG7239@us.ibm.com>
In-Reply-To: <20090624194839.GG7239@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:
> On Wed, Jun 24, 2009 at 08:45:31PM +0200, Thomas Gleixner wrote:
>> Can we just bring the limit check back and increase the number for now
>> until folks come up with a better solution ?
> 
> Another possible option is leaving in the limit check (still valid
> IMO for correct behavior of previous 'pci=use_crs') and reverting
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9e9f46c44e487af0a82eb61b624553e2f7118f5b
> until the better solution for the fixed size array issue is
> available.

Either increasing PCI_BUS_NUM_RESOURCES from 16 to 20 or 24 or
reverting f9cde5f will work for my system.

Larry
