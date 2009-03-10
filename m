Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZCJQyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZCJQyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbZCJQqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:46:47 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:42890 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbZCJQqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:46:46 -0400
Date: Tue, 10 Mar 2009 17:26:44 +0100 (CET)
From: porte64@free.fr
To: linux-kernel@vger.kernel.org
Message-ID: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
Subject: read-only partitions: does the policy apply to all metadata ?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [127.0.0.1]
X-Mailer: Zimbra 5.0.15_GA_2815.UBUNTU8_64 (zclient/5.0.15_GA_2815.UBUNTU8_64)
X-Authenticated-User: porte64@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When a partition is mounted as read-only, does the kernel
really prevent ANY byte to be written to it, including
any metadata ?

(i am thinking here about file attributes -- last access time,
as well as meta information about filesystem/blocks
description etc ...).

And is the policy implemented in every filesystem type driver
or at some abstraction level (as if the write() and like
system calls were designed to return an error).

Unfortunately, on common (all?) hard drives, there seems
to be no switch to set the device microcode in read-only
mode.

By the way, this makes me also thing about memory cards
with locks: is it a real protection or it is just a setting
which tells the kernel that it *SHOULD* mount the device
read-only ?

Please include my private address if you answer; i posted to the
list because in some other forums we did not come up
with a clear answer, so this is my last chance to get a
definite done. However i didn't subscribe to the list as
i have realized i am not able to help unfortunately:
operating systems are the most complex thing ever design by humans !

Best regards
Phil
