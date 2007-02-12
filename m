Return-Path: <linux-kernel-owner+w=401wt.eu-S964945AbXBLQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945AbXBLQsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964968AbXBLQsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:48:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:20837 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945AbXBLQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:48:42 -0500
Date: Mon, 12 Feb 2007 08:44:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Milan Markovic" <zivotinja@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Found trivial error in
 linux-headers-2.6.17-11-generic/include/linux/tty.h
Message-Id: <20070212084438.2c4a67f1.randy.dunlap@oracle.com>
In-Reply-To: <cab162590702120342p1efea5c1ua345c2cafa81f569@mail.gmail.com>
References: <cab162590702120342p1efea5c1ua345c2cafa81f569@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 12:42:22 +0100 Milan Markovic wrote:

> I upgraded the kernel on my Kubuntu 6.10 to 2.6.17-11-generic and had
> a lot of trouble compiling my softmodem driver.
> Apparently it was, among others, because of a mistake in kernel-headers
> this is what I've found in tty.h
> 
> $ cat -n /usr/src/linux-headers-2.6.17-11-generic/include/linux/tty.h
> | grep Define -C 3
>     83   */
>     84  #define TTY_NORMAL      0
>     85  #define TTY_BREAK       1
>     86  #Define Tty_Frame       2
>     87  #define TTY_PARITY      3
>     88  #define TTY_OVERRUN     4
>     89
> 
> I don't know whether it is Ubuntu-related error, or it came  from the
> top, and I wasn't really sure to whom should I address this error
> report.
> Hope this will help.

Apparently it's Ubuntu.  Linux include/linux/tty.h says:

#define TTY_NORMAL	0
#define TTY_BREAK	1
#define TTY_FRAME	2
#define TTY_PARITY	3
#define TTY_OVERRUN	4


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
