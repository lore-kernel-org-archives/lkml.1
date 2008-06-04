Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYFDAOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYFDAOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYFDANy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:13:54 -0400
Received: from ozlabs.org ([203.10.76.45]:55404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYFDANy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:13:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [RFC 1/3]  hvc_console: rework setup to replace irq functions with callbacks
Date: Wed, 4 Jun 2008 10:13:40 +1000
User-Agent: KMail/1.9.9
Cc: Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
References: <200806031444.21945.borntraeger@de.ibm.com> <200806031445.22561.borntraeger@de.ibm.com>
In-Reply-To: <200806031445.22561.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041013.40692.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 22:45:22 Christian Borntraeger wrote:
> This patch tries to change hvc_console to not use request_irq/free_irq if
> the backend does not use irqs. This allows virtio_console to use
> hvc_console without having a linker reference to request_irq/free_irq.

Two questions.  Is it possible to make the timer backoff a third kind of 
notifier?  And is it possible to make the dependency static, rather than 
dynamic, or does someone need two options at runtime?

Thanks,
Rusty.
