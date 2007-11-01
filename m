Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXKAQ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXKAQ4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKAQ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:56:06 -0400
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:55136 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbXKAQ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:56:05 -0400
X-Greylist: delayed 2861 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 12:56:05 EDT
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Thu, 01 Nov 2007 16:07:40 +0000
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit
 paravirt
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
CC: <lguest@ozlabs.org>, <kvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <ak@suse.de>, <chrisw@sous-sol.org>,
       <tglx@linutronix.de>, <anthony@codemonkey.ws>,
       <akpm@linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <mingo@elte.hu>
Message-ID: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit
 paravirt
Thread-Index: AcgcoVO4kkHFmoiUEdy2TAAX8io7RQ==
In-Reply-To: <4729F133.3060308@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/07 15:30, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Glauber de Oliveira Costa wrote:
>> I in fact have seen bugs with mixed reads and writes to the same cr,
>> (cr4), but adding the volatile
>> flag to the read function seemed to fix it.
> 
> Well, volatile will make a read be repeated rather than caching the
> previous value, but it has no effect on ordering.

volatile prevents the asm from being 'moved significantly', according to the
gcc manual. I take that to mean that reordering is not allowed.

 -- Keir


