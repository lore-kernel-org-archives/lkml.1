Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbYDAW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbYDAW3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYDAW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:29:15 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43591 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYDAW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:29:13 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Wed, 2 Apr 2008 00:29:11 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804010001.51288.chunkeey@web.de> <alpine.LFD.1.10.0804011817310.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804011817310.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020029.12019.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19VMBdPtuBto+Dq6UzWXU+/KeGzGoeOn1jur123
	+8o6irMg261a5ZvT6Fhc9mUw3X+cOFcn0U+LtMhv4bcwYJ4efi
	Hz2Qzuydg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 18:27:34 Thomas Gleixner wrote:
> On Tue, 1 Apr 2008, Chr wrote:
> > Ahhm it happend again (well, actually it's the fifth time today, but this
> > time I _hopefully_ found something)
> > 
> > (direct link)
> > http://bugzilla.kernel.org/attachment.cgi?id=15542
>
> # expires at 4839289000000 nsecs [in -168780949682 nsecs]
>
> That's strange. Local APIC timer interrupt seems to be stuck.
>
> Can you please upload a boot log and the output of
> /proc/timer_list of 2.6.24.x to the bugzilla ?
>
> Does adding "noapictimer" to the command line help ?
noapictimer seems to help too... (chrony is on)

Regards,
	Chr.
