Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYAEPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYAEPe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbYAEPes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:34:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13291 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbYAEPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=fU7fAeZ7wAgXM5C1OYs6KuRqEJRY9gN70ed7ELdzlDUo1Z5zWorwJmcQ/CjjNvTJcAAE4zCIsw7fv0ieMERcWCmLIMO35NX98WFeERXLdpAFRCyXuS05g4MbxzRb6kFsbscxOh+P0FKHWO0l25/Cib+ps/e0Gytc5jmXi96pXU8=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
       OCFS2-devel <ocfs2-devel@oss.oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       xfs-masters@oss.sgi.com, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 0/3] byteorder: introduce le32_add_cpu & friends to core
Date: Sat,  5 Jan 2008 16:36:19 +0100
Message-Id: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patchset moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
header (1st), converts ext3 filesystem to this API (2nd) and replaces
XFS different named functions with new ones (3rd).

There are many places where these functions will be useful.
Just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/
Patch for ext3 is an example how conversions will probably look like.

ps: this patchset depends on http://lkml.org/lkml/2007/12/25/35 (which is
    in ocfs2 git tree, branches: trivial, ALL)

Marcin Slusarz
