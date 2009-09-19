Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZISHFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZISHFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZISHFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:05:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbZISHFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:05:09 -0400
Date: Sat, 19 Sep 2009 12:34:32 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Alan Cox <alan@linux.intel.com>,
       rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090919070432.GB5582@amit-x200.redhat.com>
References: <20090911170010.34c80f2d@linux.intel.com> <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws> <20090911173307.GB27046@amit-x200.redhat.com> <4AAA8A56.3040707@codemonkey.ws> <20090916112332.6bf981a5@linux.intel.com> <4AB164A0.8000402@codemonkey.ws> <20090918170048.53ba8cf6@linux.intel.com> <4AB3C988.2040303@codemonkey.ws> <4AB3CA27.1040307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB3CA27.1040307@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Sep 18 2009 [10:57:59], H. Peter Anvin wrote:
> On 09/18/2009 10:55 AM, Anthony Liguori wrote:
> > 
> > I fail to see how this is at all relevant.  This is a virtual machine,
> > we're presenting virtual hardware that behaves like a serial device. 
> > Where web servers fit in is completely beyond me.
> > 
> 
> s/virtio_console/virtio_serial/
> 
> There is a fairly noticeable difference between a "console device" and a
> "serial device".  However, something that can be extended and exported
> to a physical serial port is definitely the latter.

The patch series did start out as a virtio_serial device. The qemu
maintainers had a problem supporting both, the pre-existing
virtio_console device and the new virtio_serial device as in essence
they're the same thing. So even though this patch adds all the support
in the virtio_console driver, it's really a virtio_serial transport with
a console supported on one of the ports (or multiple, if needed).

To maintain backward compatibility in the current scenario, though, I
chose not to rename the virtio_console driver to virtio_serial.

		Amit
-- 
http://log.amitshah.net/
