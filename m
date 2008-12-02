Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYLBP1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYLBP1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 10:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYLBP1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 10:27:01 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51982 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbYLBP1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 10:27:00 -0500
X-Sasl-enc: tRuVMSUEn0ThRriMBBB7+bAqHXKPm/5+D6YuIvDB33v2 1228231618
Date: Tue, 2 Dec 2008 13:26:56 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andreas Dilger <adilger@sun.com>
Cc: Andres Freund <andres@anarazel.de>, Theodore Tso <tytso@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20081202152656.GH1668@khazad-dum.debian.net>
References: <200811291418.24672.andres@anarazel.de> <200812011335.00366.andres@anarazel.de> <20081201194204.GZ3186@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201194204.GZ3186@webber.adilger.int>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008, Andreas Dilger wrote:
> - do the applications writing to this file have any unusual IO pattern
>   (e.g. mmap IO, lots of write+truncate+write on the same file, etc)

Vuze does a massive ammount of sparse writes.  It can also be configured to
pre-allocate space (either by creating an empty non-sparse file, or by
telling the kernel that the file is expected to grow to size foo and to
please pre-allocate that in the filesystem.  I don't recall how this is
done).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
