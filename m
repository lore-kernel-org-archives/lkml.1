Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYJNIW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYJNIW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYJNIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:22:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:55386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYJNIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:22:14 -0400
Subject: Re: [RFC 1/3] hvc_console: rework setup to replace irq functions
	with callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200810140842.31806.borntraeger@de.ibm.com>
References: <200806031444.21945.borntraeger@de.ibm.com>
	 <200810130951.31733.borntraeger@de.ibm.com>
	 <1223944714.8157.300.camel@pasglop>
	 <200810140842.31806.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 19:18:51 +1100
Message-Id: <1223972331.8157.331.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 08:42 +0200, Christian Borntraeger wrote:
> Am Dienstag, 14. Oktober 2008 schrieb Benjamin Herrenschmidt:
> > 
> > > Hmmm. 
> > > Can you try if this patch fixes the lockdep trace?
> > 
> > Yup, the patch fixes it, I'll commit it via the powerpc.git tree if you
> > don't have any objection.
> 
> Sure, go ahead.

Allright, I have a batch about ready to go to Linus, so I'll add that
and ask him to pull tomorrow.

Thanks,
Ben.


