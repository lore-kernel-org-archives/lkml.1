Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYDYGJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYDYGJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYDYGJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:09:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37110 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYDYGJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:09:20 -0400
Date: Fri, 25 Apr 2008 09:09:18 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before	mounting
 root
In-Reply-To: <20080424225604.GA18737@kroah.com>
Message-ID: <Pine.LNX.4.64.0804250907120.27149@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Greg KH wrote:
> What happens if there is no USB device present in the system?  Because
> of that, there is no way that this option could ever be enabled by any
> distro or anyone wanting their kernel to run on more than one machine :(

Not sure what you mean. If there are no USB devices present on the system, 
the boot proceeds as usual. The config option will make the kernel wait 
only if you have a USB mass storage device (or some other device that 
cause async SCSI scanning) _plugged in_.

		Pekka
