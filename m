Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbZCYFtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbZCYFtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZCYFtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:49:13 -0400
Received: from gw.goop.org ([64.81.55.164]:59652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZCYFtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:49:12 -0400
Message-ID: <49C9C5D2.3050000@goop.org>
Date: Tue, 24 Mar 2009 22:49:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
References: <49C915A3.3020809@goop.org> <20090324174859.GB31117@elte.hu> <49C921A8.3090200@goop.org> <49C96728.8070808@zytor.com>
In-Reply-To: <49C96728.8070808@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I was mostly objecting to the apic patches -- I'm okay with the latest 
> version, as long as they aren't in hot code (I never got the time to 
> measure it.)

None of the changes are in the interrupt delivery path; they all just 
during apic discovery and interrupt routing/setup.

    J
