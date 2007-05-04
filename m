Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXEDNy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXEDNy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXEDNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:54:27 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:46044
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbXEDNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:54:26 -0400
Message-ID: <463B4988.9090005@microgate.com>
Date: Fri, 04 May 2007 08:56:08 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <200705041049.20989.oliver@neukum.org>	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com> <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com> <463B46F4.6090906@microgate.com>
In-Reply-To: <463B46F4.6090906@microgate.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:
> A new function to flush the tty flip buffer needs to
> be added and then called from tty_io.c:tty_ldisc_flush().

That is not enough.

It looks like tty_ioctl() needs to process ioctl(TCFLSH)
to clear the flip buffer before passing that ioctl
to the line discipline.

-- 
Paul Fulghum
Microgate Systems, Ltd.
