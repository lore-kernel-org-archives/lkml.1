Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYJQSrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYJQSrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYJQSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:47:22 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:57507 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYJQSrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:47:21 -0400
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only
	filesystem
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
In-Reply-To: <E1KqrTW-0001x8-3h@dylan>
References: <E1KqrTW-0001x8-3h@dylan>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:27:07 -0400
Message-Id: <1224268027.18940.78.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking through the code I see two references to xattrs, one is the
index of the xattr table in the superblock and there seems to be struct
member in one of the inode structures that is an index into this table.
Looking through the code I don't see either of these used at all. Do you
intend to add xattr support at some point? I saw reference to the desire
to add xattr support in an email from 2004 but you said that the code
has been rewritten since then. If you are going to add xattr support you
probably want to add it to more than just regular files. In SELinux and
other LSMs symlinks and directories are also labeled so they will need
xattr entries.

Dave

