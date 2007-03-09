Return-Path: <linux-kernel-owner+w=401wt.eu-S1767310AbXCIOSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767310AbXCIOSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767315AbXCIOSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:18:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:46639 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767310AbXCIOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H33RzNMpvLoT4hSezHc/fXpWam+jrtzbSErQ7tD96GF/p/bH0Ugtjf7sEKXei7rUITVHWWzov1gkz0XwJyuJrRuT+TcDmUDOAO9ZhMoEPhNK3kCawG15Cfab2jykeBKF8dkbu2zE3v1lIvbTHx/B06XOrx83ahoCcJYPFT7sg/A=
Message-ID: <57354eff0703090618q17d80f53p25b904d552fc30c@mail.gmail.com>
Date: Fri, 9 Mar 2007 15:18:48 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Oleksiy Kebkal" <kebkal@gmail.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
In-Reply-To: <20070308204020.GE30023@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <200703080844.32157.rgetz@blackfin.uclinux.org>
	 <20070308134800.GA30023@flint.arm.linux.org.uk>
	 <200703081523.39698.rgetz@blackfin.uclinux.org>
	 <20070308204020.GE30023@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> ... which occurs /after/ userspace is up and running, when sysfs is
> available.  So putting it in sysfs is reasonable.

Is it right place for serial settings?
/sys/class/tty/ttySN/

How far is it reasonable to split termios settings to the attributes?
1)
/sys/class/tty/ttyS0/termios
2)
/sys/class/tty/ttyS0/c_iflag
/sys/class/tty/ttyS0/c_oflag
/sys/class/tty/ttyS0/c_cflag
/sys/class/tty/ttyS0/c_lflag
/sys/class/tty/ttyS0/c_cc
3)
/sys/class/tty/ttyS0/speed
/sys/class/tty/ttyS0/eof
/sys/class/tty/ttyS0/eon
/sys/class/tty/ttyS0/erase
.... and so on


-Oleksiy
