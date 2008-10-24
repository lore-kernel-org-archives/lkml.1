Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYJXVx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYJXVx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYJXVxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:53:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:57503 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYJXVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:53:50 -0400
Message-ID: <fa686aa40810241453o876ae14tce3df7723b0f621b@mail.gmail.com>
Date: Fri, 24 Oct 2008 15:53:49 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH] [powerpc] GPIO: Adding new Xilinx driver
Cc: "John Linn" <john.linn@xilinx.com>, jwboyer@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, "Kiran Sutariya" <kirans@xilinx.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081024214159.GA15204@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081024195908.7D1A1142806C@mail74-wa4.bigfish.com>
	 <20081024214159.GA15204@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 3:41 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Fri, Oct 24, 2008 at 12:59:00PM -0700, John Linn wrote:
>> This driver supports the Xilinx XPS GPIO IP core which has the typical
>> GPIO features.
>>
>> Signed-off-by: Kiran Sutariya <kirans@xilinx.com>
>> Signed-off-by: John Linn <john.linn@xilinx.com>
>
> Looks good. Just few comments below.
>
<snip>
>
> If nothing has changed, we should place the arch-specific GPIO
> drivers into the arch/. So, Kconfig entry should go into the
> arch/powerpc/platforms/Kconfig.
>
> and the driver itself into arch/powerpc/sysdev/.

This isn't just a powerpc driver.  It is also used by microblaze so
I'd like to keep it in the common directory (Microblaze is in the
process of being reviewed for merging).

Thanks for the comments.
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
