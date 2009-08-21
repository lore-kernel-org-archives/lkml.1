Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZHUWaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZHUWaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 18:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933049AbZHUWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 18:30:22 -0400
Received: from claw.goop.org ([74.207.240.146]:56077 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbZHUWaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 18:30:21 -0400
Message-ID: <4A8F1FEA.1060706@goop.org>
Date: Fri, 21 Aug 2009 15:30:02 -0700
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
Subject: Re: [RFC patch 16/32] x86: Replace ARCH_SETUP by a proper platform
 function
References: <20090821205008.518392436@linutronix.de> <20090821205602.584376844@linutronix.de>
In-Reply-To: <20090821205602.584376844@linutronix.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/09 14:30, Thomas Gleixner wrote:
> ARCH_SETUP is a horrible hack of paravirt/xen which is way nicer to
> read as a platform setup function.
>   

Not really correct; its a left-over from the old subarch stuff.  But it
was certainly never very pretty.

    J
