Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZINQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZINQpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZINQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:45:36 -0400
Received: from kroah.org ([198.145.64.141]:40683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbZINQpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:45:34 -0400
Date: Mon, 14 Sep 2009 09:43:33 -0700
From: Greg KH <greg@kroah.com>
To: e9hack <e9hack@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trouble with USB serial driver (ftdi_sio.c) on 2.6.31
Message-ID: <20090914164333.GB25381@kroah.com>
References: <4AAB8F3F.40403@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAB8F3F.40403@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 02:08:31PM +0200, e9hack wrote:
> Hi,
> 
> I've some trouble with the USB serial driver (ftdi_sio.c for a FT232RL from FTDI). If the 
> port is opened for the first time, the driver works perfectly. If the port is closed and 
> open again, it isn't possible to read any data from port. Writing data to the port works. 
> The FT232RL must be reconnect to get it working again. A reboot without reconnect doesn't 
> solve this problem. If I look at the debug output, I don't see read requests from 
> ftdi_sio.c. If reading is possible, I see this read messages:

{sigh}  Yes, this driver is a bit messed up in .31, sorry.  We are
working through it and hope to have a fix in one of the upcoming
.31-stable releases.

thanks,

greg k-h
