Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXEJJuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXEJJuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXEJJt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:49:59 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643AbXEJJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:49:58 -0400
Date: Thu, 10 May 2007 02:48:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-Id: <20070510024837.39be3396.akpm@linux-foundation.org>
In-Reply-To: <20070510002740.c4350813.akpm@linux-foundation.org>
References: <20070321074121.GA13843@enneenne.com>
	<20070502193314.GA23367@enneenne.com>
	<20070510002740.c4350813.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 00:27:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> - Can we get rid of the private dbg, err and info macros?  Surely there are
>   generic ones somewhere.

i386 allmodconfig:

In file included from drivers/usb/misc/uss720.c:48:
include/linux/usb.h:1505:1: warning: "dbg" redefined
In file included from include/linux/parport.h:108,
                 from drivers/usb/misc/uss720.c:46:
include/linux/pps.h:139:1: warning: this is the location of the previous definition
In file included from drivers/usb/misc/uss720.c:48:
include/linux/usb.h:1511:1: warning: "err" redefined
In file included from include/linux/parport.h:108,
                 from drivers/usb/misc/uss720.c:46:
include/linux/pps.h:145:1: warning: this is the location of the previous definition
In file included from drivers/usb/misc/uss720.c:48:
include/linux/usb.h:1513:1: warning: "info" redefined
In file included from include/linux/parport.h:108,
                 from drivers/usb/misc/uss720.c:46:
include/linux/pps.h:147:1: warning: this is the location of the previous definition


