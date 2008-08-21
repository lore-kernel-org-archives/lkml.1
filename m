Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYHUJGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYHUJGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYHUJGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:06:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:6364 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYHUJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:content-disposition:from:date:mime-version
         :content-type:content-transfer-encoding:message-id:sender;
        b=Ca6WyY/OyJUjVFIRlPFsbrGsvRrOHolDC0Ul1Gp+ojy7DOUteKMNQUqQpbgKMRDUQ0
         MWDKvCUgD20fjBRf5H8in0Kqwb57eS8YAQnPVDY/jCufTjChr58yDIdZ25Ho9Q39GeH1
         6ioiqoiVXBhb/v8NYwlz0/ZaHYyR9x/CavRZc=
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: EXT3-fs error
Cc: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
From: Eric Lacombe <tuxiko@free.fr>
Date: Thu, 21 Aug 2008 11:06:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200808211106.39574.tuxiko@free.fr>
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

