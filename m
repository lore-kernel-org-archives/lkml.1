Return-Path: <linux-kernel-owner+w=401wt.eu-S934608AbXK3Nh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608AbXK3Nh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934558AbXK3Nh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:37:29 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:4195 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762699AbXK3Nh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:37:27 -0500
Date: Fri, 30 Nov 2007 14:37:24 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Message-ID: <20071130133724.GE11682@osiris.boeblingen.de.ibm.com>
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com> <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com> <20071130115015.GC11682@osiris.boeblingen.de.ibm.com> <3f9a31f40711300408s4341a338n33e5b6dbaee05813@mail.gmail.com> <20071130124958.GD11682@osiris.boeblingen.de.ibm.com> <3f9a31f40711300500h6d13625ua08417ae53acbbea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40711300500h6d13625ua08417ae53acbbea@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 06:30:45PM +0530, Jaswinder Singh wrote:
> We have two options:
> 
> 1. Either move arch/s390/crypto/Kconfig to drivers/crypto/Kconfig
> 
> OR
> 
> 2. In arch/s390/crypto/Kconfig , replace "depends on S390" to "depends
> on CRYPRO_HW"
> 
> I think 2nd option is better for everyone.

2) won't work and doesn't make too much sense. So it's 1).
This isn't worth discussing any furter.

Thanks.
