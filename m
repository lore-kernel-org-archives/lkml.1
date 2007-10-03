Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXJCDIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXJCDIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 23:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXJCDIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 23:08:07 -0400
Received: from ozlabs.org ([203.10.76.45]:41961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbXJCDIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 23:08:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18179.943.277895.633795@cargo.ozlabs.ibm.com>
Date: Wed, 3 Oct 2007 12:51:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>
Subject: Re: [PATCH 4/5] ibmebus: Move to of_device and of_platform_driver, match eHCA and eHEA drivers
In-Reply-To: <200709261145.51926.fenkes@de.ibm.com>
References: <200709261143.24735.fenkes@de.ibm.com>
	<200709261145.51926.fenkes@de.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joachim Fenkes writes:

> Replace struct ibmebus_dev and struct ibmebus_driver with struct of_device
> and struct of_platform_driver, respectively. Match the external ibmebus
> interface and drivers using it.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
>  drivers/net/ehea/ehea.h                   |    2 +-
>  include/asm-powerpc/ibmebus.h             |   38 +++------------
>  arch/powerpc/kernel/ibmebus.c             |   28 ++++++-----
>  drivers/infiniband/hw/ehca/ehca_eq.c      |    6 +-
>  drivers/infiniband/hw/ehca/ehca_main.c    |   32 ++++++------
>  drivers/net/ehea/ehea_main.c              |   72 ++++++++++++++--------------

This is somewhat difficult as this patch touches files that are the
responsibility of three different maintainers.  Is it possible to
split the patch into three, one for each maintainer (possibly by
keeping both old and new interfaces around for a little while)?

If not, then you need to get an Acked-by and an agreement that this
change can go via the powerpc.git tree from Roland Dreier and Jeff
Garzik.

Paul.
