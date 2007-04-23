Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXDWPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXDWPwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXDWPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:52:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49542 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753878AbXDWPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:52:16 -0400
Date: Mon, 23 Apr 2007 16:55:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: Re: Prevent softlockup triggering in nvidiafb
Message-ID: <20070423165505.4aecd186@the-village.bc.nu>
In-Reply-To: <20070423151053.GA5653@redhat.com>
References: <20070423151053.GA5653@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 11:36:30 -0400
Dave Jones <davej@redhat.com> wrote:

> If the chip locks up, we get into a long polling loop,
> where the softlockup detector kicks in.
> See https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=151878
> for an example.

Surely in this situation the softlockup report and trap out is precisely
what should be occurring.

