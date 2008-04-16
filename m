Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYDPJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYDPJtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbYDPJtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:49:12 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:10133
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbYDPJtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:49:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYBAKdoBUh8qMMq/2dsb2JhbAAIrkc
X-IronPort-AV: E=Sophos;i="4.25,664,1199631600"; 
   d="scan'208";a="302955609"
Subject: Re: RFC: Self-snapshotting in Linux
From: Ben Nizette <bn@niasdigital.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>
In-Reply-To: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
References: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 16 Apr 2008 19:49:07 +1000
Message-Id: <1208339347.3361.35.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 16:44 +0800, Peter Teoh wrote:
> Essentially, to reiterate the key idea:   able to snapshot the current
> kernel+userspace permanent.....restore from another snapshot....and
> then switch back again if needed etc.....will the implementation be
> difficult...if not impossible????
> 

As I see it the main thing is that VMWare doesn't have to worry about
trying to put hardware in to (and pull out of) low power modes.  VMWare
hardware is never left in an undefined state by poorly written drivers
etc.

I think hibernation is about what you want; snapshotting as you describe
it should fall down for about the same reasons :-)

	--Ben.
