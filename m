Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZIQQBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZIQQBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZIQQBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:01:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50358 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755916AbZIQQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:01:08 -0400
Date: Thu, 17 Sep 2009 17:02:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
Message-ID: <20090917170233.61eecc4f@lxorguk.ukuu.org.uk>
In-Reply-To: <4AB244E0.1060109@windriver.com>
References: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
	<4AB1B860.4080105@windriver.com>
	<20090917101441.478b3e9b@lxorguk.ukuu.org.uk>
	<4AB22892.8000308@windriver.com>
	<20090917140828.21341c05@lxorguk.ukuu.org.uk>
	<20090917141913.47f9451b@lxorguk.ukuu.org.uk>
	<4AB244E0.1060109@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should the "struct console co*" get a new member for the baud, or should
> it get a termios?  The source of the problem is how to inherit the
> termios setting from the first user (the console code in this case).

I think the console should probably have a ktermios structure and that is
something which in future could become more generic (arguably in a saner
world the termios would belong to the tty_port in the end as and when
everything is a tty port - which would make a whole ton of things a lot
lot more logical)
