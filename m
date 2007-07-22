Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXGVMve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXGVMve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbXGVMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:51:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49986 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXGVMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:51:22 -0400
Date: Sun, 22 Jul 2007 13:51:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jacob A <jacoba51-tmp@yahoo.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
Message-ID: <20070722125120.GY21668@ftp.linux.org.uk>
References: <259547.37103.qm@web57705.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <259547.37103.qm@web57705.mail.re3.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 04:39:14AM -0700, Jacob A wrote:
> Al,
> 
> I'm using the open/close call as a way for processes to register/unregister with a watchdog driver that I'm writing.
> I thought that I can save the housekeeping within the driver, but it looks like It would be easier just to maintain my own list
> and be done with it.

What do you mean "register with a watchdog driver"?  The process that
had opened file might be long gone while the file remains open...

What kind of information do you keep for each struct file?

PS: stop top-posting
