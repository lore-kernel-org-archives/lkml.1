Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZEETkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZEETkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZEETkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:40:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:49231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672AbZEETkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:40:08 -0400
Message-Id: <20090505193014.926371851@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 05 May 2009 15:30:14 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Al Viron <viro@ZenIV.linux.org.uk>
Subject: [patch 0/3] reiserfs xattr fixups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This series consists of three patches:

 1) rework the bit of locking after Al's privroot lookup patch
 2) Fix up security xattrs so they don't apply to other xattrs
 3) Clean up the privroot hiding since we now cache the privroot early

 -Jeff


