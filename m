Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbXJPTvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbXJPTvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935093AbXJPTvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:51:20 -0400
Received: from www17.your-server.de ([213.133.104.17]:52302 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935621AbXJPTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:51:19 -0400
Message-ID: <47151631.9000307@m3y3r.de>
Date: Tue, 16 Oct 2007 21:51:13 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Look at this:

$ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
0x1, Prompt for Videomode

$ file /boot/bzImage-2.6.23
/boot/bzImage-2.6.23: Linux kernel x86 boot executable RO-rootFS,
root_dev 0x803, swap_dev 0x1, Normal VGA

and this:

# kexec -l arch/x86/boot/bzImage
Cannot determine the file type of arch/x86/boot/bzImage

How to solve this error?

mfg
thomas

