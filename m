Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbXFMFpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbXFMFpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 01:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXFMFpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 01:45:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXFMFp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 01:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=K9umYoUcUANHCux6iKxLeWnUI+/kJ2t2utUOIDcINl2qvIQ6Xt9BbZbJ/kCM7Xc9A5KFXjVeyG2Z9ggqEILjLf+I+wWdZgNREccm05ECHoVRA84KiiZPKhu9K9i/0Y570nPoxl0LHMhvHPXZnpVse58FjQLdgdQqi0ogwzfaIuw=
Message-ID: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com>
Date: Wed, 13 Jun 2007 01:45:28 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, snitzer@gmail.com
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neat! It's great to see somebody else waking up to the idea that
storage media is NOT to be trusted.

Judging by the design paper, it looks like your structs have some
alignment problems.

The usual wishlist:

* inode-to-pathnames mapping
* a subvolume that is a single file (disk image, database, etc.)
* directory indexes to better support Wine and Samba
* secure delete via destruction of per-file or per-block random crypto keys
* fast (seekless) access to normal-sized SE Linux data
* atomic creation of copy-on-write directory trees
* immutable bits like UFS has
* hole punch ability
* insert/delete ability (add/remove a chunk in the middle of a file)
