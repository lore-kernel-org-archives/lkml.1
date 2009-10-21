Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZJULwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZJULwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZJULwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:52:18 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.29]:51926 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZJULwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:52:18 -0400
Message-ID: <4ADEF595.3080604@ladisch.de>
Date: Wed, 21 Oct 2009 13:50:45 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: hpet: Convert to unlocked_ioctl
References: <alpine.LFD.2.00.0910182210220.3462@localhost.localdomain> <alpine.LFD.2.00.0910211340540.3526@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910211340540.3526@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur wrote:
> This patch converts the hpet_ioctl to the unlocked version. It is meant to 
> be applied after the patch that removed the BKL from the hpet_open 
> function.
> 
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 21 Oct 2009 13:34:42 +0200
> Subject: [PATCH] hpet: Convert to unlocked_ioctl
> 
> The ioctl functions here rely on their own locking using the hpet_lock spinlock.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
(for both patches)
