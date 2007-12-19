Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbXLSKNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbXLSKNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLSKNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:13:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXLSKN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:13:29 -0500
Date: Wed, 19 Dec 2007 11:12:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 1/2] remove __init modifier from header declaration
Message-ID: <20071219101236.GB3521@elte.hu>
References: <11979967763153-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11979967763153-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> This patch removes the __init modifier from an extern function 
> declaration in acpi.h.
> 
> Besides not being strictly needed, it requires the inclusion of 
> linux/init.h, which is usually not even included directly, increasing 
> header mess by a lot.

thanks, applied.

btw., people have been talking about reducing the include file mess for 
nearly a decade now, but it didnt get that much better - at least not in 
include/asm-x86/*.h. So include file dependency flattening patches would 
be more than welcome as well. (and unlike unification patches they have 
no expectation of being 100% perfect, so a natural ping-pong of fixes, 
until the changes are fully correct, would be natural.)

	Ingo
