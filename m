Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbZFNNhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbZFNNhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZFNNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:37:13 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:54873 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbZFNNhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:37:12 -0400
Message-ID: <4A34FD06.2020204@xs4all.nl>
Date: Sun, 14 Jun 2009 15:37:10 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: crypt issue with 2.6.30/gcc 4.4.0?
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am having trouble decrypting my dm-crypted disks with 2.6.30. 2.6.29.4
works fine with the same encrypted disks.
I've been upgrading to Fedora 11 in the past few days so now GCC 4.4.0
is the compiler, that may (also) be a factor.

On 2.6.92.4 I see the encryption password prompt being buried by a lot
of USB-messages from connected gear. I can 'blindly' type my password
and asterisks appear for each letter. At the end of the password I press
Enter; a complaint about the partition table for md1 is displayed and
booting continues.
With 2.6.30 I see the Password prompt being repeated, after all the USB
messages, as soon as I press the first letter of the password. Each time
the password is entered it is not accepted and a new Password: prompt is
printed up to a total of three tries.

For all of these boots into 2.6.29.4 or 2.6.30 the userland etc is the
same (Fedora 11), it is just that 2.6.29.4 was built while running
Fedora 10 and 2.6.30 is now built with the tools in 2.6.30.
I did boot into 2.6.30 (built while running Fedora 10) successfully
once, right after the upgrade to Fedora 11. Later I made small changes
to the kernel config and rebuilt the kernel and this made the encryption
password fail. A `make clean` and rebuild does not fix the issue

How can I find out what's the cause for the password issue?

Kind regards,
Udo
