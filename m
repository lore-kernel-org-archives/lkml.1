Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbZFQOqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbZFQOqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbZFQOpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:45:49 -0400
Received: from smtpn2.emerion.com ([212.69.178.34]:50412 "EHLO
	smtps02.emerion.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763569AbZFQOps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:45:48 -0400
X-Greylist: delayed 2530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jun 2009 10:45:48 EDT
From: Philipp Marek <philipp.marek@emerion.com>
Organization: Emerion.com
To: linux-kernel@vger.kernel.org
Subject: Changing the data of hardlinked symlinks
Date: Wed, 17 Jun 2009 16:03:38 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-2-amd64; KDE/4.2.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906171603.39497.philipp.marek@emerion.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I'd like to know if there's something I'm missing, or whether that's simply 
not possible currently - or won't ever because of POSIX.

I have hardlinks of symlinks, like this:
	# ls -la
	-rw-r--r--  1 root root     0 Jun 17 15:36 daten
	drwxr-xr-x  2 root root  4096 Jun 17 15:37 daten2
	lrwxrwxrwx  3 root root     5 Jun 17 15:36 link -> daten
	lrwxrwxrwx  3 root root     5 Jun 17 15:36 link2 -> daten
	lrwxrwxrwx  3 root root     6 Jun 17 15:37 link3 -> daten2
	lrwxrwxrwx  3 root root     6 Jun 17 15:37 link4 -> daten2
	lrwxrwxrwx  3 root root     5 Jun 17 15:36 link5 -> daten
	lrwxrwxrwx  3 root root     6 Jun 17 15:37 link6 -> daten2

Now I'd like to change the inode of one of the symlinks, but in a way that 
*all* symlinks sharing the inode are changed, too.

"ln -f" doesn't work; "man symlink" and "man link" let me believe that it's 
not possible.


I even looked at debugfs, but from a quick look I only saw how to read the 
data of an inode ("cat") - nothing to write it back.


Is there some way to do that?


Regards,

Phil

