Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZHOKdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZHOKdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZHOKdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:33:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZHOKdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:33:04 -0400
Date: Sat, 15 Aug 2009 12:32:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Cc: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090815103243.GA26749@elte.hu>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814154308.26116.46980.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> This will generally be used for hypervisors to publish any host-side
> virtual devices up to a guest.  The guest will have the opportunity
> to consume any devices present on the vbus-proxy as if they were
> platform devices, similar to existing buses like PCI.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  MAINTAINERS                 |    6 ++
>  arch/x86/Kconfig            |    2 +
>  drivers/Makefile            |    1 
>  drivers/vbus/Kconfig        |   14 ++++
>  drivers/vbus/Makefile       |    3 +
>  drivers/vbus/bus-proxy.c    |  152 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/vbus_driver.h |   73 +++++++++++++++++++++
>  7 files changed, 251 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/vbus/Kconfig
>  create mode 100644 drivers/vbus/Makefile
>  create mode 100644 drivers/vbus/bus-proxy.c
>  create mode 100644 include/linux/vbus_driver.h

Is there a consensus on this with the KVM folks? (i've added the KVM 
list to the Cc:)

	Ingo
