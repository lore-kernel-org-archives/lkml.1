Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbYBNFAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbYBNFAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbYBNFAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:00:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44184 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYBNFAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:00:09 -0500
Date: Wed, 13 Feb 2008 21:02:11 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214050211.GB1432@kroah.com>
References: <47B30291.2040905@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B30291.2040905@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 01:15:37AM +1030, David Newall wrote:
> Consider a USB-attached serial port that is set to do RTS/CTS (or
> DSR/DTR) handshaking: What stops the kernel sending more data to it when
> the remote end lowers CTS (or DTR)?

The tty layer should look at the proper flags and not send data on to
the driver in this kind of instance.

Is this not happening properly for you?  If so, which USB serial driver?

thanks,

greg k-h
