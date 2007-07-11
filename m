Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXGKTAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXGKTAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXGKTA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:00:27 -0400
Received: from h155.mvista.com ([63.81.120.155]:27255 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbXGKTA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:00:26 -0400
Message-ID: <46952943.2080007@ru.mvista.com>
Date: Wed, 11 Jul 2007 23:02:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] mmio ide support for mpc8349-itx target
References: <20070707094852.9473.21013.stgit@localhost.localdomain>	<20070707094900.9473.48577.stgit@localhost.localdomain>	<468FC376.2040405@ru.mvista.com> <20070710145256.6ac64e11@localhost.localdomain>
In-Reply-To: <20070710145256.6ac64e11@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vitaly Bordug wrote:

>>>+
>>>+#ifdef CONFIG_MPC834x_ITX  

>>    Erm, isn't this stuff misplaced? Is this really SoC device? I
>>remember seeng this in the arch/ppc/ platform code before (in the
>>internal tree)...

> The point is to declare methods bsp, as mmio access may effectively vary (having bugs or intentionally) from platform to platform. All-in-one driver approach is nice but might be an issue to handle/maintain.

    You misunderstood. Why this was placed in fsl_soc.c and not in the proper 
platform code (as it was in the internal tree even)?

MBR, Sergei
