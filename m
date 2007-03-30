Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXC3Jaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXC3Jaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXC3Jaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:30:55 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:4809 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbXC3Jay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:30:54 -0400
Subject: Re: Why is arch/s390/crypto/Kconfig sourced when building for
	another arch ?
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <eueg41$j5t$1@sea.gmane.org>
References: <eueg41$j5t$1@sea.gmane.org>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 09:30:12 +0000
Message-Id: <1175247012.5474.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> with 2.6.20.4 it works great, but when switching to 2.6.21-rcX it breaks 
> with this:
> 
> drivers/crypto/Kconfig:55: can't open file "arch/s390/crypto/Kconfig"

arch/s390/crypto/Kconfig is included there since that is the right place
for the config options to show up.

> I tried to fix drivers/crypto/Kconfig by changing the code to:
> 
> if S390
> source "arch/s390/crypto/Kconfig"
> endif
> 
> but it still gets sourced...

You would need something like:

source "arch/s390/crypto/Kconfig"
	depends on S390

But that is not implemented and I doubt it will since deleting parts of
the kernel tree is not something that is required to work.

Jan

