Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbZLGD6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbZLGD6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbZLGD6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:58:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33856 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111AbZLGD6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:58:51 -0500
Date: Mon, 7 Dec 2009 03:58:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091207035857.GF14381@ZenIV.linux.org.uk>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Updated series posted, with fixes merged.  It should also cover
the shm bug caught by dwg - in case of hugepage shm we ended up with
oopsen due to b0rken ->get_unmapped_area().
