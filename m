Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYDILTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYDILTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYDILTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:19:24 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:19892 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYDILTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=h4bydn3pA3cYEK3ShORpJTD0oKDmYMtMgAQGK2XhOMfnzCfZA5tHH1dockUf9sAFoSEvcg+W7QU0xC3lRJEMxmbuQHFZrPVE8xXbTpngtJ7fVvdfBIdlJ8h1nXqf8mTi6MXaOZXXUqJ6NLGqybjH4yd8WerEWOd50BHxSA+LvlQ=
Message-ID: <cf40c6a90804090419o59bc215cw6068b7f2118efcfe@mail.gmail.com>
Date: Wed, 9 Apr 2008 13:19:22 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Plenty of inactive memory
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

i got a weird problem with one of my servers. It's a Intel SR2500AL
with 32GB of RAM.
Looking at the memory usage of the system, something is going totally
wrong. The crucial numbers from /proc/meminfo are:

MemTotal: 33265916 kB
MemFree: 416168 kB
Inactive: 24630428 kB (24GB? whooaaa)

Another system with only 16GB, same amount of users and load, shows a
more normal behaviour:

MemTotal: 16619808 kB
MemFree: 6912676 kB
Inactive: 1774364 kB

Why does the 32GB-System have this plenty of inactive memory. Is there
a way to find out, what the kernel is holding in readiness?

OS: SLES 10 SP1
Kernel : 2.6.16.27-0.9-bigsmp

Thanks in advance.

Andreas Grimm
