Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYHUCiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYHUCiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYHUCio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:38:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12458 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYHUCin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id:sender;
        b=ECgejXtti62mSPH9DM0+BxDDB6B0ehMb3ln04GrnhNfunRVmsfxJhR5c3C95SlrDZh
         XG7szAllSFLHLnwE5sQvNRTeMetT6EVjeM1THGYRz3ey5njTR+axaL31MxPw7TgvDE0I
         dXTg7ManA0PJA8kONhmlLPEyg7fhCFDG3OcFA=
From: Eric Lacombe <tuxiko@free.fr>
To: LKML <linux-kernel@vger.kernel.org>
Subject: EXT3-fs error
Date: Thu, 21 Aug 2008 04:38:36 +0200
User-Agent: KMail/1.9.9
Cc: Theodore Tso <tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210438.37244.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, my computer freezes a lot, and I noted the problems below. I wonder 
if my hard disk is going die.
Can someone confirm or infirm my suspicion?

Notes:
- I run a 2.6.26.2 kernel
- After the last entry in the log (captured from a ssh connexion) my computer 
froze after ~1 minute. Thereafter I had to run fsck manually and the FS has 
been repaired.

Thanks in advance,

Regards,

	Eric

-------------
Aug 21 03:29:11 hoth EXT3-fs error (device sdb3) in ext3_reserve_inode_write: 
IO failure
Aug 21 03:29:27 hoth attempt to access beyond end of device
Aug 21 03:29:27 hoth sdb3: rw=1, want=9223372036891258616, limit=51199155
Aug 21 03:29:27 hoth Buffer I/O error on device sdb3, logical block 
1152921504611407326
Aug 21 03:29:27 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:29 hoth attempt to access beyond end of device
Aug 21 03:29:29 hoth sdb3: rw=1, want=9223372036861435904, limit=51199155
Aug 21 03:29:29 hoth Buffer I/O error on device sdb3, logical block 
1152921504607679487
Aug 21 03:29:29 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:29 hoth attempt to access beyond end of device
Aug 21 03:29:29 hoth sdb3: rw=1, want=9223372036861547048, limit=51199155
Aug 21 03:29:29 hoth Buffer I/O error on device sdb3, logical block 
1152921504607693380
Aug 21 03:29:29 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:29 hoth attempt to access beyond end of device
Aug 21 03:29:29 hoth sdb3: rw=1, want=9223372036861572888, limit=51199155
Aug 21 03:29:29 hoth Buffer I/O error on device sdb3, logical block 
1152921504607696610
Aug 21 03:29:29 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:30 hoth attempt to access beyond end of device
Aug 21 03:29:30 hoth sdb3: rw=1, want=9223372036861709648, limit=51199155
Aug 21 03:29:30 hoth Buffer I/O error on device sdb3, logical block 
1152921504607713705
Aug 21 03:29:30 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:32 hoth attempt to access beyond end of device
Aug 21 03:29:32 hoth sdb3: rw=1, want=9223372036870258504, limit=51199155
Aug 21 03:29:32 hoth Buffer I/O error on device sdb3, logical block 
1152921504608782312
Aug 21 03:29:32 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:32 hoth attempt to access beyond end of device
Aug 21 03:29:32 hoth sdb3: rw=1, want=9223372036870344016, limit=51199155
Aug 21 03:29:32 hoth Buffer I/O error on device sdb3, logical block 
1152921504608793001
Aug 21 03:29:32 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:36 hoth attempt to access beyond end of device
Aug 21 03:29:36 hoth sdb3: rw=1, want=9223372036865888112, limit=51199155
Aug 21 03:29:36 hoth Buffer I/O error on device sdb3, logical block 
1152921504608236013
Aug 21 03:29:36 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:41 hoth attempt to access beyond end of device
Aug 21 03:29:41 hoth sdb3: rw=1, want=9223372036871715240, limit=51199155
Aug 21 03:29:41 hoth Buffer I/O error on device sdb3, logical block 
1152921504608964404
Aug 21 03:29:41 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:42 hoth attempt to access beyond end of device
Aug 21 03:29:42 hoth sdb3: rw=1, want=9223372036889223112, limit=51199155
Aug 21 03:29:42 hoth Buffer I/O error on device sdb3, logical block 
1152921504611152888
Aug 21 03:29:42 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:42 hoth attempt to access beyond end of device
Aug 21 03:29:42 hoth sdb3: rw=1, want=9223372036890192904, limit=51199155
Aug 21 03:29:42 hoth Buffer I/O error on device sdb3, logical block 
1152921504611274112
Aug 21 03:29:42 hoth lost page write due to I/O error on sdb3
Aug 21 03:29:43 hoth attempt to access beyond end of device
Aug 21 03:29:43 hoth sdb3: rw=1, want=9223372036889927584, limit=51199155
Aug 21 03:29:43 hoth Buffer I/O error on device sdb3, logical block 
1152921504611240947
Aug 21 03:29:43 hoth lost page write due to I/O error on sdb3

[~3 more lines not relative to previous errors]

------------------

