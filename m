Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbYLHSSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbYLHSSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYLHSSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:18:43 -0500
Received: from kuber.nabble.com ([216.139.236.158]:59807 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYLHSSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:18:42 -0500
Message-ID: <20900699.post@talk.nabble.com>
Date: Mon, 8 Dec 2008 10:18:41 -0800 (PST)
From: Dennis Hardy <dhardy@sogetthis.com>
To: linux-kernel@vger.kernel.org
Subject: CIFS regression in 2.6.27.8
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: dhardy@sogetthis.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just mounted a network drive (Windows Server) via CIFS under 2.6.27.8, and
the sizes reported by "df" are completely incorrect:

  root@exodus:~# df -h /mnt/fsv1
  Filesystem            Size  Used Avail Use% Mounted on
  //fsv1/Users          446G -222G  667G   -  /mnt/fsv1
  root@exodus:~# df /mnt/fsv1
  Filesystem           1K-blocks      Used Available Use% Mounted on
  //fsv1/Users         467403140 -231816588 699219728   -  /mnt/fsv1
  root@exodus:~# mount | grep fsv1
  //fsv1/Users on /mnt/fsv1 type cifs (rw,mand)
  root@exodus:~#

Does anyone else see this sort of behavior with 2.6.27.8?  This worked fine
in 2.6.27.6 (we skipped 2.6.27.7)...

Ideas?


-- 
View this message in context: http://www.nabble.com/CIFS-regression-in-2.6.27.8-tp20900699p20900699.html
Sent from the linux-kernel mailing list archive at Nabble.com.

