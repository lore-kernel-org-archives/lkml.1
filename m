Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZALOxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZALOxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZALOxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:53:18 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:49916 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZALOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:53:17 -0500
Message-ID: <496B597A.7020807@lougher.demon.co.uk>
Date: Mon, 12 Jan 2009 14:53:46 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias@kaehlcke.net>, phillip@lougher.demon.co.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG?] SQUASHFS error: Major/Minor mismatch
References: <20090112140822.GB23365@traven>
In-Reply-To: <20090112140822.GB23365@traven>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke wrote:
> i get the following error when trying to mount a squashfs partition on
> an ARM system (edb9302) with linux 2.6.29-rc1:
> 
> mount /dev/mtdblock6 /mnt/
> SQUASHFS error: Major/Minor mismatch, older Squashfs 3.1 filesystems
> are unsupported
> mount: mounting /dev/mtdblock6 on /mnt/ failed: Invalid argument
> 
> the image has been created using mksquashfs v3.4:
> 
> mksquashfs . /tmp/rootfs.squfs -le -noappend
> 

You have to use the latest version of Mksquashfs in CVS available
from http://squashfs.org.

git-cvsimport -v -d :pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs squashfs

Phillip

