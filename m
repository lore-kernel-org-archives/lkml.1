Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbXBNUl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbXBNUl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXBNUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:41:55 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44617 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXBNUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:41:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 21/21] Xen-paravirt: Add the Xen virtual network device driver.
References: <20070213221729.772002682@goop.org>
	<20070213221831.150207238@goop.org>
Date: Wed, 14 Feb 2007 13:40:01 -0700
In-Reply-To: <20070213221831.150207238@goop.org> (Jeremy Fitzhardinge's
	message of "Tue, 13 Feb 2007 14:17:50 -0800")
Message-ID: <m1odnwpj6m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> +++ b/drivers/xen/Kconfig.net
> @@ -0,0 +1,14 @@
> +menu "Xen network device drivers"
> +        depends on NETDEVICES && XEN
> +
> +config XEN_NETDEV_FRONTEND
> +	tristate "Network-device frontend driver"
> +	depends on XEN
> +	default y
> +	help
> +	  The network-device frontend driver allows the kernel to access
> +	  network interfaces within another guest OS. Unless you are building a
> +	  dedicated device-driver domain, or your master control domain
> +	  (domain 0), then you almost certainly want to say Y here.

Am I reading this correctly I can directly use the network interface
of another guest OS (no protection)?

I think this description is misleading, and probably say something
about virtual hardware.

Eric
