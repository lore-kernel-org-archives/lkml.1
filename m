Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXFJLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXFJLwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 07:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXFJLwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 07:52:02 -0400
Received: from mailgate.ics.forth.gr ([139.91.1.2]:52512 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbXFJLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 07:52:01 -0400
X-Greylist: delayed 3018 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 07:52:01 EDT
Message-ID: <1181473295.466bda0f80347@webmail.ics.forth.gr>
Date: Sun, 10 Jun 2007 14:01:35 +0300
From: mcatos@ics.forth.gr
To: linux-kernel@vger.kernel.org
Subject: Block device request queue processing question
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.1
X-Originating-IP: 62.1.100.152
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am developing a stacking block driver and so far the driver was accepting
requests using the 'make_request' function (without a queue). When I switched to
using a request queue, I noticed that the driver received much more reuquests in a
single call, which is very good for me.

The problem is that the driver must initiate I/O towards the physical device,
which cannot be done inside the function that services the requests. Is there a
way I can process all the request in a context where sleeping is permitted?

I tried to dequeue all the requests using 'blkdev_dequeue_request' but I do not
know how to properly handle request completion.

Thanx in advance.



-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/

