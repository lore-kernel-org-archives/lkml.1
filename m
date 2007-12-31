Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXLaKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXLaKGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXLaKGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 05:06:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:35607 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXLaKGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 05:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PL8dhUT7/DF8CT1bp/BcyBrBbQZviX3DBFmGQegvNzIqRqOSp8oPjeKiQFH0XbdtiS3I/jRf8rkNnHqexG1MO7zAv8U0eHxXBY/YZbi2nq11pjOIAoMPrC3QSi5vbgYYJ5lA5aXosQA3pmHu/fsYKHA9P5ZM1GvxagowlrZJ/64=
Message-ID: <2cf50a010712310206v2e116cbclc25e812846bd4030@mail.gmail.com>
Date: Mon, 31 Dec 2007 21:06:14 +1100
From: "Jack Andrews" <effbiae@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: wanting to use mmap
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i read the O_DIRECT january thread:
  http://kerneltrap.org/mailarchive/linux-kernel/2007/1/11/44365

i am interested in using mmap as a quick way of getting data
to and from disk.  i also want to handle errors (like bad blocks)
as well as is possible using usual read/write calls.

would i be right in saying that
  a) mmap+madvise+msync
provides almost the same function as
  b) read/write(2)+posix_fadvise+fsync

i have read that fault-tolerance or error-handling is 'better'
using (b). what does this mean exactly?  i note that write(2)
may return EIO - what happens if the same underlying error
occurs when accessing a mmap'ed file?  i notice that in the
implementation of msync, fsync is called so errno might be
set to EIO...

ta, jack
(please cc: me)
