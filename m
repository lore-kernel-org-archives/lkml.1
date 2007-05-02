Return-Path: <linux-kernel-owner+w=401wt.eu-S1767231AbXEBXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767231AbXEBXeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767238AbXEBXeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:34:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51315 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767231AbXEBXeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:34:22 -0400
Date: Wed, 2 May 2007 16:37:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-Id: <20070502163734.070d5047.randy.dunlap@oracle.com>
In-Reply-To: <200705030000.29272.hjk@linutronix.de>
References: <20070427224957.GA17967@kroah.com>
	<200705021041.35422.hjk@linutronix.de>
	<20070502135237.59a46232.randy.dunlap@oracle.com>
	<200705030000.29272.hjk@linutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 00:00:28 +0200 Hans-Jürgen Koch wrote:

> Am Mittwoch 02 Mai 2007 schrieb Randy Dunlap:
> > On Wed, 2 May 2007 10:41:35 +0200 Hans-Jürgen Koch wrote:
> > > Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:
> > > > > +<title>The Userspace I/O HOWTO</title>
> > > >
> > > > Most of this reads well.  Thanks.
> > > > A few typo corrections are below...
> > >
> > > Thank you for your work. I generated a new patch that includes all your
> > > suggestions and also fixes the build problems.

OK, your fixes all look good, but still needs one minor fix (below).

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix last UIO kernel-doc problem.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/uio/uio.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.21-git4.orig/drivers/uio/uio.c
+++ linux-2.6.21-git4/drivers/uio/uio.c
@@ -582,7 +582,6 @@ static void uio_class_destroy(void)
 
 /**
  * uio_register_device - register a new userspace IO device
- *
  * @owner:	module that creates the new device
  * @parent:	parent device
  * @info:	UIO device capabilities
