Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXGIUI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXGIUI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXGIUIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:08:22 -0400
Received: from deliverator3.gatech.edu ([130.207.165.163]:57666 "EHLO
	deliverator3.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXGIUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:08:22 -0400
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 16:08:22 EDT
Message-ID: <1184010444.469290cce48df@webmail.mail.gatech.edu>
Date: Mon, 09 Jul 2007 15:47:24 -0400
From: vraghavan3@mail.gatech.edu
To: linux-kernel@vger.kernel.org
Subject: Reading a physical memory location
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 64.102.85.146
X-Authenticated-User: vraghavan3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--
Hey all,

I know the physical address of a string which is loaded into flash memory. I
want to read the string at the known physical memory location from within a
kernel module. I initially tried reading the "/dev/mem" file using open(),
lseek() and read(). But I guess its not possible to call these functions from a
kernel module.

Is there some way of reading the contents of this physical memory location from
within a kernel module?

Thank You
Veena
