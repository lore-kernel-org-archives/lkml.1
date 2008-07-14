Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYGNC5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYGNC5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbYGNC5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:57:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:20526 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbYGNC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:subject;
        b=CQ21Xw5xkcNVDvELt83vfgcfqMQ7TqdEwXEJsczvtN2SLw5JUlcF2DySBFFxuRfEJ3
         UIu89cH97F0fDGP+LYbHpY8WRZyTkUPTI5cxOtPUCNnfpUAEM7jt9fZTGrbER8N/uvPD
         S/7XCUZyWqoIo3RyTzDwNf4fEkl+Ur+rltmG8=
Message-Id: <20080714025631.338886297@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jul 2008 11:56:31 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch -mmotm 0/6] move memory_read_from_buffer() from fs.h to string.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley said that inclusion of linux/fs.h in a low level driver
was always a danger signal. This patch moves memory_read_from_buffer()
from fs.h to string.h and remove inclusion of linux/fs.h in existing
memory_read_from_buffer() users and -mm patches

