Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZLTRkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZLTRkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZLTRkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:40:40 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:55201 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZLTRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:40:40 -0500
From: jidanni@jidanni.org
To: 561764@bugs.debian.org
Cc: linux-kernel@vger.kernel.org, 561229@bugs.debian.org
Subject: Re: Bug#561764: some warnings fly off screen and are not saved in any file
Date: Mon, 21 Dec 2009 01:39:45 +0800
Message-ID: <87skb5zgri.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, via
$ zcat /boot/initrd.img-2.6.32-trunk-686|strings|less
I think I found one of the messages I saw:
SYSFS{}= will be removed in a future udev version
which is in /sbin/udevadm ... bug #561229 perhaps.

However, what I'm saying is "how bad it is that there be any messages
that fly off the screen at boot and are not also 'remembered into some
log file' one can read later?".

Either remember all messages into those /var/log/ files, or remember
none. Remembering 95% makes one think that they see all of them.

There is some step so early in the boot process that recording has not
been turned on yet. That step is making error messages that fly off the
screen... with only one small laptop one is not going to be able to see these
messages. One should not be required to attach other equipment to see them.
