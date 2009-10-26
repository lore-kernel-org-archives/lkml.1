Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZJZJQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZJZJQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 05:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZJZJQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 05:16:51 -0400
Received: from bamako.nerim.net ([62.4.17.28]:61805 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbZJZJQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:16:51 -0400
Date: Mon, 26 Oct 2009 10:16:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: 2.6.32-rc5-git3 -- WARNING: drivers/hwmon/lm90: 'pv_lock_ops' 
  exported twice. Previous export was in vmlinux
Message-ID: <20091026101653.069fc078@hyperion.delvare>
In-Reply-To: <a44ae5cd0910251632i71ebdebcpeb00e7d4c8f1ae3d@mail.gmail.com>
References: <a44ae5cd0910251632i71ebdebcpeb00e7d4c8f1ae3d@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles,

On Sun, 25 Oct 2009 19:32:44 -0400, Miles Lane wrote:
> WARNING: drivers/hwmon/lm90: 'pv_lock_ops' exported twice. Previous
> export was in vmlinux
> drivers/hwmon/lm93.o: Invalid argument
> make[1]: *** [__modpost] Error 1

Your config builds just fine here with gcc 4.3.2 and binutils 2.19. The
above warning doesn't make any sense to me, the lm90 driver is
definitely not exporting pv_lock_ops. I suspect either source tree
corruption or build chain problems. Either way, this isn't something I
can help you with, sorry.

-- 
Jean Delvare
