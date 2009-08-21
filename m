Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbZHUWTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbZHUWTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZHUWTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:19:14 -0400
Received: from claw.goop.org ([74.207.240.146]:46004 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbZHUWTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:19:14 -0400
Message-ID: <4A8F1D5A.5030501@goop.org>
Date: Fri, 21 Aug 2009 15:19:06 -0700
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
Subject: Re: [RFC patch 00/32] x86: Refactor the setup code to provide a base
 for	embedded platforms
References: <20090821205008.518392436@linutronix.de>
In-Reply-To: <20090821205008.518392436@linutronix.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/09 14:29, Thomas Gleixner wrote:
> The following patch series refactors the setup related x86_quirks and
> the setup related paravirt hooks and puts them into an extensible
> platform_setup infrastructure to provide a proper base for adding the
> Moorestown modifications. As a side effect it also unifies
> time_32/64.c and removes some leftovers of the pre arch/x86 era.
>   

I haven't gone through the patches at all yet, but I definitely like
this direction.  I've got some local patches to generalize x86_quirks a
bit, and I'm hoping that you've already subsumed them; if not, it should
be easy to extend on top of your patches.

    J
