Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZHUWXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZHUWXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZHUWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:23:11 -0400
Received: from claw.goop.org ([74.207.240.146]:59056 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZHUWXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:23:10 -0400
Message-ID: <4A8F1E4D.9080409@goop.org>
Date: Fri, 21 Aug 2009 15:23:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [RFC patch 02/32] x86: Add probe_roms to platform_setup
References: <20090821205008.518392436@linutronix.de> <20090821205601.878468441@linutronix.de>
In-Reply-To: <20090821205601.878468441@linutronix.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/09 14:29, Thomas Gleixner wrote:
[argh attachments]
> probe_roms is only used on 32bit. Add it to the platform_setup code
> and remove the #ifdefs.
>
> Default initializer is platform_setup_noop() which is overridden in
> the 32bit boot code.
>
>   

I realize you're aiming to make this transform have no functional
side-effects, but is there a good reason why probe_roms *couldn't* be
done in 64-bit?  It seems to me that its useful for coverage
completeness to have the 32 and 64 bit do the same thing even if its
sometimes redundant.

    J
