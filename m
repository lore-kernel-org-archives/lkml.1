Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZEKPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZEKPGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZEKPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:06:09 -0400
Received: from mail.pentek.com ([12.35.250.145]:4833 "HELO mailhost.pentek.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752808AbZEKPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:06:09 -0400
X-Greylist: delayed 1542 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 11:06:08 EDT
Message-ID: <4A0838D1.5090102@pentek.com>
Date: Mon, 11 May 2009 10:40:17 -0400
From: Steve Rottinger <steve@pentek.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: splice methods in character device driver
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Has anyone successfully implemented the splice() method's in a character
device driver?
I'm having a tough time finding any existing drivers that implement
these method's, which
I can use as an example. Specifically, it is unclear to me, as to how I
need to set up .ops
in the splice_pipe_desc, when using splice_to_pipe(). 
My ultimate goal is to use splice to move data from a high speed data
acquisition device,
which has a buffer in PCI space to disk without the need for going
through block memory.

Thanks,

-Steve

