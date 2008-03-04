Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbYCDAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbYCDAWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYCDAWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:22:13 -0500
Received: from ozlabs.org ([203.10.76.45]:43535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYCDAWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:22:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] Use spin_lock_irqsave/restore for virtio-pci
Date: Tue, 4 Mar 2008 11:21:30 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <1204497468-13463-1-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <1204497468-13463-1-git-send-email-aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200803041121.30288.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008 09:37:48 Anthony Liguori wrote:
> virtio-pci acquires its spin lock in an interrupt context so it's necessary
> to use spin_lock_irqsave/restore variants.  This patch fixes guest SMP when
> using virtio devices in KVM.
>
> Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

Thanks, applied.

Rusty.
