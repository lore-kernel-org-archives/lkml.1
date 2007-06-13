Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbXFML4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbXFML4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbXFML4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:56:44 -0400
Received: from mailgate.ics.forth.gr ([139.91.1.2]:59628 "EHLO
	mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbXFML4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:56:43 -0400
Message-ID: <1181735790.466fdb6e87626@webmail.ics.forth.gr>
Date: Wed, 13 Jun 2007 14:56:30 +0300
From: mcatos@ics.forth.gr
To: linux-kernel@vger.kernel.org
Subject: Request merging not doing well
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.1
X-Originating-IP: 195.74.248.25
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I did some tests to see how requet merging works. Using a dummy ramdisk block
device, I did 'dd count=100 bs=4096 if=/dev/zero of=/dev/foo' (using the
anticipatory scheduler) and in the request function I got 10 requests:

req 1, sector 0, 8 sectors
req 2, sector 8, 8 sectors
.
.
.
req 10, sector 72, 8 sectors

Shouldn'y these requests be merged? Queue default values are: 255 max sectors,
128 max requests.

Thanx.

-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/

