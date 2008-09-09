Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYIIIjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYIIIjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 04:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYIIIjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 04:39:43 -0400
Received: from scing.com ([217.160.110.58]:49881 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYIIIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 04:39:42 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 04:39:42 EDT
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Date: Tue, 9 Sep 2008 10:32:50 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080909070603.GA5786@x200.localdomain>
In-Reply-To: <20080909070603.GA5786@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091032.51462.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 09:06:03 Alexey Dobriyan wrote:
>
> All version.h and autoconf.h inclusions aren't needed.

I'll remove them.

> #ifdef MODULE is gross and very old. Don't need that. Just use
>
> 	static int __init x_init(void)
> 	{
> 		...
> 	}
>
> 	static void __exit x_exit(void)
> 	{
> 		...
> 	}
> 	module_init(x_init);
> 	module_exit(x_exit);
> 	MODULE_LICENSE
> 		...
>
> It will work correctly in modular and built-in case.

Will do so.

> Static number of devices is simple but how about adding them
> dynamically.

Will have a look

Janne
