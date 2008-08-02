Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYHBWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYHBWZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 18:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYHBWZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 18:25:28 -0400
Received: from gw.beattie-home.net ([66.93.38.225]:52614 "EHLO
	mail.beattie-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYHBWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 18:25:27 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2008 18:25:27 EDT
Subject: ioctl's suck?
From: Brian Beattie <beattie@beattie-home.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 02 Aug 2008 14:54:56 -0700
Message-Id: <1217714096.6280.35.camel@kokopelli>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other day Linus (I think) made the statement, that I don't disagree
with, that I will parapharse as "ioctl's suck".  If I recall correctly
and understand he was saying that a device that uses ioctls is broken.
(this is my paraphrase and if it offends anybody it is my fault not the
original author's).

This got me to thinking about a device driver that I'm working on.
Currently I have some ioctls to handle status and out of band messages
and I'm wondering about eliminating the ioctls.  I'm wondering if
anybody has any ideas or opinions that they would like to share, about
just what i wrong with ioctls and/or how to avoid them.

I can see a number of problems with ioctls that I can'tr quite put into
words.

I could add a control device and pass ascii strings for status and OOB
messages, would that be an improvement?
-- 
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting a bad thing?

Brian Beattie   LFS12947 | "Honor isn't about making the right choices.
beattie@beattie-home.net | It's about dealing with the consequences."
www.beattie-home.net     | -- Midori Koto


