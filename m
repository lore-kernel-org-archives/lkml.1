Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0BUX5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:57:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60260
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334Ab0BUX5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:57:02 -0500
Date: Sun, 21 Feb 2010 15:57:19 -0800 (PST)
Message-Id: <20100221.155719.226789440.davem@davemloft.net>
To: rob@landley.net
Cc: qemu-devel@nongnu.org, blauwirbel@gmail.com, pbonzini@redhat.com,
       atar4qemu@googlemail.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002211025.11588.rob@landley.net>
References: <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com>
	<201002201712.23628.rob@landley.net>
	<201002211025.11588.rob@landley.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>
Date: Sun, 21 Feb 2010 10:25:09 -0600

> 085219f79cad89291699bd2bfb21c9fdabafe65f is first bad commit
> commit 085219f79cad89291699bd2bfb21c9fdabafe65f
> Author: Sam Ravnborg <sam@ravnborg.org>
> Date:   Fri Jan 2 18:47:34 2009 -0800
> 
>     sparc32: use proper types in struct stat
>     
>     Like sparc64 use proper types in struct stat
>     
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> This commit breaks stat and makes sparc32 essentially unusable.  It changes 
> the size of the various types in stat.h, and means that if you "mount -t tmpfs 
> /tmp /tmp" and then try to ls /tmp, ls dies with a memory allocation error.
> 
> I've confirmed that reverting it fixes the problem.

Thanks for tracking this down Rob, I'll work on a fix and
push it around.
