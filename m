Return-Path: <linux-kernel-owner+w=401wt.eu-S2992735AbXBQRHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992735AbXBQRHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 12:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992479AbXBQQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:58:05 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:9324 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S2992475AbXBQQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:57:58 -0500
Date: Sat, 17 Feb 2007 11:57:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dan Aloni <da-x@monatomic.org>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] OOM and USB, latest Linux 2.6
In-Reply-To: <20070217164920.GA31755@localdomain>
Message-ID: <Pine.LNX.4.44L0.0702171156300.4173-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007, Dan Aloni wrote:

> Hello,
> 
> Is it possible that OOM isn't handled very well if say, my entire
> file system structure is on a USB storage device?
> 
> I'm not an expert on this particular matter but I'm pretty sure 
> that I noticed GFP_KERNEL allocation being done on the write-out 
> path in the usb-storage kernel thread, leading to a deadlock 
> during OOM.

Can you be any more specific than that?  usb-storage should use only 
GFP_NOIO in its I/O paths.

Alan Stern

