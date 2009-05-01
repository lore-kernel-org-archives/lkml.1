Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbZEAWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbZEAWxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbZEAWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:53:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60658
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbZEAWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:53:05 -0400
Date: Fri, 01 May 2009 15:52:59 -0700 (PDT)
Message-Id: <20090501.155259.185618790.davem@davemloft.net>
To: alex.williamson@hp.com
Cc: rusty@rustcorp.com.au, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Cleanup command queue scatterlist usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1241217794.9646.588.camel@2710p.home>
References: <20090427154925.4771.63651.stgit@debian.lart>
	<20090501.153301.42015656.davem@davemloft.net>
	<1241217794.9646.588.camel@2710p.home>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@hp.com>
Date: Fri, 01 May 2009 16:43:14 -0600

> On Fri, 2009-05-01 at 15:33 -0700, David Miller wrote:
>> From: Alex Williamson <alex.williamson@hp.com>
>> Date: Mon, 27 Apr 2009 09:50:03 -0600
>> 
>> > We were avoiding calling sg_init* on scatterlists passed
>> > into virtnet_send_command to prevent extraneous end markers.
>> > This caused build warnings for uninitialized variables.
>> > Cleanup the code to create proper scatterlists.
>> > 
>> > Signed-off-by: Alex Williamson <alex.williamson@hp.com>
>> 
>> This patch does not apply even to Linus's current tree.
> 
> It was against net-next-2.6.git, I'll update it for linux-2.6.git.
> IIRC, it applied with some fuzz.

Thanks.  I want to apply this to net-2.6 to fix those uninitialed
scatterlist structure issues.
