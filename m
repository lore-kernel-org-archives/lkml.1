Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYFFR3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYFFR3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYFFR3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:29:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30197 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYFFR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z3p9U5GTHNOOKe5BHaQJZMQBp3UXo4LsAmrkvN6SUOuXJvD2thaitsm+byAuFvUXjf
         UzRhu41hES/SqMrRD56D9b9kSJRFXcmC8VKqw/alQV+qWlL1/i8VyTZj2qiimjQ8Cpcy
         he+qYpkp6DVGPgBbE3AZ4Vpg6GUPKkOlh6xsE=
Date: Fri, 6 Jun 2008 21:29:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: NMI watchdog downgrade changes
Message-ID: <20080606172921.GB7051@cvg>
References: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Fri, Jun 06, 2008 at 03:27:02AM +0100]
| Ingo,
| 
|  This is a series of patches in response to your earlier report to fix the
| problem where the I/O APIC NMI watchdog is attempted where it should not
| be, fails and then disables the timer leading the system to a fatal
| failure.  Please put in tip/x86/apic, replacing the patch named
| nosmp-watchdog or 'x86: APIC/SMP: Downgrade the NMI watchdog for "nosmp"'
| in the sequence.
| 
|   Maciej
| 

I've tested it over tip/x86/apic and it solved problems for me.
Thanks Maciej!

		- Cyrill -
