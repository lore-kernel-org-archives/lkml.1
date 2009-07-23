Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZGWLlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZGWLlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZGWLlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:41:46 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:54369 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbZGWLlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:41:45 -0400
Date: Thu, 23 Jul 2009 12:41:22 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: 2.6.31-rc3-current-git+ build failure
Message-ID: <20090723114122.GB6570@console-pimps.org>
References: <c6b1100b0907221302l330ad3dfx494c943426b97eef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b1100b0907221302l330ad3dfx494c943426b97eef@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:02:57PM +0100, Chris Clayton wrote:
> After a git pull about 20 minutes ago (that would be about 20:30 here
> in UK) th eresultant kernel fails to build with the message:@
> 
> kernel/irq/manage.c: In function 'irq_thread_check_affinity':
> kernel/irq/manage.c:475: error: 'struct irq_desc' has no member named 'affinity'
> make[2]: *** [kernel/irq/manage.o] Error 1
> make[1]: *** [kernel/irq] Error 2
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....
> 
> I believe this is caused by commit:
> 
> 591d2fb02ea80472d846c0b8507007806bdd69cc
> 

Patch here, http://patchwork.kernel.org/patch/36923/
