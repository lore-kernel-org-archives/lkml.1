Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZALOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZALOIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZALOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:08:33 -0500
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:56112
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbZALOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:08:32 -0500
Date: Mon, 12 Jan 2009 15:08:22 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: phillip@lougher.demon.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: [BUG?] SQUASHFS error: Major/Minor mismatch
Message-ID: <20090112140822.GB23365@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i get the following error when trying to mount a squashfs partition on
an ARM system (edb9302) with linux 2.6.29-rc1:

mount /dev/mtdblock6 /mnt/
SQUASHFS error: Major/Minor mismatch, older Squashfs 3.1 filesystems
are unsupported
mount: mounting /dev/mtdblock6 on /mnt/ failed: Invalid argument

the image has been created using mksquashfs v3.4:

mksquashfs . /tmp/rootfs.squfs -le -noappend

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
