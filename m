Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZACXii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZACXii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZACXi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:38:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:7588 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZACXi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nnSvrc+Cjauk/xvTYs0ifHdeZ5osBvSJ6ucwtDHVXqXsQdqn8CSCtm3ACrDpJDvh8Q
         8uQmwZ3jCztJnr2D0gR+gfWuQoGBmIawi59KlTHm8qPJINUlaISR5+lhCht6l5QBwHdX
         IpYOFMDvY05gXfSLeIKyyrWpUz+/8fwWnIZaM=
Message-ID: <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:38:25 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: document ext3 requirements
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <495FEE66.9080903@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <495FD5D7.2040907@ribosome.natur.cuni.cz>
	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
	 <20090103222957.GG1666@elf.ucw.cz>
	 <495FEE66.9080903@ribosome.natur.cuni.cz>
X-Google-Sender-Auth: 0a08ebfd4bfbcd96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> Hmm, so if my dual-boot machine does not shutdown correctly and I boot
> accidentally in M$ Win where I use ext2 IFS driver and modify some
> stuff on the ext3 drive, after a while reboot to linux and the journal
> get re-played ... Mmm ...

You *really* wouldn't want to be doing that.

The other scenario that people have reported trouble with is
suspending the system, booting a live CD which "read-only" mounts the
filesystem (and replays the journal), then resuming.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
