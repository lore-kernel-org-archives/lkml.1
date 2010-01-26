Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563Ab0AZGln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0AZGln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903Ab0AZGll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:41:41 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37959 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0AZGll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:41:41 -0500
Date: Tue, 26 Jan 2010 12:01:27 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Greg KH <greg@kroah.com>
Cc: Himanshu Chauhan <himanshu@symmetricore.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>
Subject: Re: sysfs_ops show vector: size of buffer not required?
Message-ID: <20100126063127.GA2369@himanshu-laptop>
References: <20100124074118.GA4201@himanshu-laptop>
 <20100126043646.GB32066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126043646.GB32066@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 08:36:46PM -0800, Greg KH wrote:
> On Sun, Jan 24, 2010 at 01:11:18PM +0530, Himanshu Chauhan wrote:
> > Hi All,
> > 
> > The sysfs_ops's show vector doesn't have a size of the
> > buffer given to the vector, while store on the other hand
> > has. What is the rationale behind it?
> 
> If you need to check the size, you are doing something wrong.
> 
> Seriously, that is the reason.  A sysfs file should be a single value,
> which will never overflow the buffer.
> 
I was talking in context of usb/ip's show_status. It writes a lot of data
into this buffer. Which seems to over flow the buffer. But anyways, I
will check if it can be reduced or at least be splitted into differnt
device attributes.

BTW, Greg, Did you take a look at other patches I had sent? Are are worth or
I need rework?

Regards
Himanshu
