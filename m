Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYHFMxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYHFMxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYHFMxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:53:31 -0400
Received: from anguilla.debian.or.at ([86.59.118.152]:42035 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYHFMxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:53:31 -0400
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 08:53:31 EDT
Date: Wed, 6 Aug 2008 14:33:01 +0200
From: Peter Palfrader <weasel@debian.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.26.1 hangs on dl385
Message-ID: <20080806123301.GJ25710@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <weasel@debian.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to upgrade several of our HP DL385 running a 64 bit kernel to
2.6.26.1 from 2.6.25.11.

Every single one of them died within at most a few days, sometimes even
within minutes.  The systems continue to do TCP/IP/pings/etc, but
everything that interacts with the filesystem/disks just hangs.  It
seems to happen faster with more disk/filesystem load.  Nothing is
printed to the console.

The kernel config of the working 2.6.25.11 and of several 2.6.26.1
kernels, none of wich worked realiably, can be found
at http://asteria.noreply.org/~weasel/dl385/

Any idea what likely suspects could be, i.e. what I should try to
disable in the kernel config?  Any patches I should try?

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
