Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYFCMog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYFCMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 08:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYFCMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 08:44:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:21968 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYFCMo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 08:44:26 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linux PPC devel <linuxppc-dev@ozlabs.org>
Subject: [RFC 0/3]: hvc_console rework for platform without hard irqs
Date: Tue, 3 Jun 2008 14:44:21 +0200
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031444.21945.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set if my first attempt to make virtio_console usable on s390.
To do so, I had to change hvc_console, because s390 has no request_irq and
no free_irq.
I want to get feedback from the main users of hvc_console before I proceed.

The basic idea of this patch set is to remove the calls to request_irq and
free_irq and replace them with backend specific callbacks.

Please see the descriptions of the patches for further details:

1/3: hvc_console: rework setup to replace irq functions with callbacks
2/3: virtio_console: use virtqueue notification for hvc_console
3/3: s390: use virtio_console for KVM on s390
