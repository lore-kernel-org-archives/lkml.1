Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbYBNJpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbYBNJpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765448AbYBNJpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:45:40 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:41607 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYBNJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:45:38 -0500
From: "Tom Van Looy" <assarix@pandora.be>
To: "rzryyvzy" <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Importance: Normal
Sensitivity: Normal
Message-ID: <W8217824349298681202982295@nocme1bl6.telenet-ops.be>
X-Originating-IP: [81.83.46.237]
X-Forwarded-For: [10.10.1.191]
Date: Thu, 14 Feb 2008 09:44:55 +0000
Subject: Re: Is there a 
Reply-To: assarix@pandora.be
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can create a symlink to /dev/null and name it whatever you want?

$ ln -s /dev/null tempfile
$ echo blablabla > tempfile
$ wc tempfile
0 tempfile




>----- Oorspronkelijk bericht -----
>Van: rzryyvzy [mailto:rzryyvzy@trashmail.net]
>Verzonden: donderdag, februari 14, 2008 10:30 AM
>Aan: linux-kernel@vger.kernel.org
>Onderwerp: Is there a "blackhole" /dev/null directory?
>
>Hello Linux Kernel Hackers,
>
>/dev/null is often very useful, specially if programs force to save data in some file. But some programs like to creates different temporary file names, so /dev/null could no more work.
>
>What is with a "/dev/null"-directory?
>I mean a "blackhole pseudo directory" which eats every write to null.
>
>Here is how it could work:
>mount -t nulldir nulldir /dev/nulldir
>
>Now if a program does a create(2),
>it creates in the memory the file with its fd.
>Then if a program does a write(2) to the fd, it eats the writes and give out fakely it has written the number of bytes.
>When the program calls does a close(2) of the fd, then the complete inode is deleted in the memory.
>
>The directory should  be permanently empty except for the inodes with open file descriptors. So only inode information would be temporary saved in this "nulldir tmpfs" directory.
>
>Is there already existing a possibility to create a null directory?
>-- 
>Best regards,
>Mika Lawando
>
>-- 
>E-Mail sent with anti-spam site TrashMail.net!
>Free disposable email addresses: http://www.trashmail.net/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>
>


