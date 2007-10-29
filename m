Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbXJ2WyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbXJ2WyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJ2WyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:54:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55221 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbXJ2WyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:54:13 -0400
Subject: Re: [PATCH] raise tsc clocksource rating
From: Zachary Amsden <zach@vmware.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
In-Reply-To: <20071029224852.GA27547@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com>
	 <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
	 <20071029224852.GA27547@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 15:55:05 -0700
Message-Id: <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 23:48 +0100, Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:

> if it's inaccurate why are you exposing it to the guest then? Native 
> only uses the TSC if it's safe and accurate to do so.

Not every guest support paravirt, but for correctness, all guests
require TSC, which must be exposed all the way up to userspace, no
matter what the efficiency or accuracy may be.

Zach

