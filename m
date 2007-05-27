Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXE0QPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXE0QPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbXE0QPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:15:02 -0400
Received: from outpost.ds9a.nl ([213.244.168.210]:36570 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbXE0QPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:15:00 -0400
Date: Sun, 27 May 2007 18:14:58 +0200
From: bert hubert <bert.hubert@netherlabs.nl>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: USB: set default y for CONFIG_USB_DEVICE_CLASS
Message-ID: <20070527161458.GA1749@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org
References: <20070527150458.GA3803@vrfy.org> <9a8748490705270910q2fde0e19i1e60393cef7b86d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490705270910q2fde0e19i1e60393cef7b86d4@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 06:10:41PM +0200, Jesper Juhl wrote:
> >        bool "USB device class-devices (DEPRECATED)"
> >        depends on USB
> >-       default n
> >+       default y
> 
> It puzzles me why a deprecated option should be default 'Y'...

Because if it defaults to 'n', a 'make oldconfig' will break unmodified
userspace on reboot, which is something we don't want to do in a 'stable'
series, without announcing it first for a serious length of time.

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
