Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbYFDLQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbYFDLQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbYFDLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:16:06 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:6602 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbYFDLQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:16:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 1/3]  hvc_console: rework setup to replace irq functions with callbacks
Date: Wed, 4 Jun 2008 13:15:42 +0200
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031445.22561.borntraeger@de.ibm.com> <200806041013.40692.rusty@rustcorp.com.au>
In-Reply-To: <200806041013.40692.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041315.42593.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juni 2008 schrieb Rusty Russell:
> Two questions.  Is it possible to make the timer backoff a third kind of 
> notifier?

I can try. The timer handling code is sprinkled a bit in hvc_console but it 
should be possible.

> And is it possible to make the dependency static, rather than  
> dynamic, or does someone need two options at runtime?

Not sure. Some drivers pass get the irq number from another component. If the 
number is 0, the console is poll driven, otherwise irq driven.
