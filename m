Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZBKPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZBKPxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZBKPxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:53:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34989 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754852AbZBKPxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:53:23 -0500
Date: Wed, 11 Feb 2009 10:53:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-kernel@vger.kernel.org, <mm-commits@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
       <linux-input@vger.kernel.org>
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
In-Reply-To: <49928FDB.5020007@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0902111009260.3056-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009, Jiri Slaby wrote:

> On 02/11/2009 01:36 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-10-16-35 has been uploaded
> 
> Hi,
> 
> when I resume from suspend, USB mouse and kbd are not responding anymore, no
> LEDs, nothing. I need to unplug and replug to get it working. This is a
> regression since mmotm based on 2.6.29-rc2 which is fine.
> 
> Any ideas before I start bisection?

In theory the lack of S4 support shouldn't cause this to happen.

You might want to build a kernel with CONFIG_USB_DEBUG enabled.  The 
extra debugging information should help find the problem.

Alan Stern

