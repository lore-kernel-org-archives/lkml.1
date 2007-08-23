Return-Path: <linux-kernel-owner+w=401wt.eu-S1764697AbXHWP27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764697AbXHWP27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761020AbXHWP2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:28:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:14255 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759279AbXHWP2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dvyrMj7JrBWVUaQDI15OPxKGxHrITEDQRNJyfdqK/Lh7zlnMhql9Et27ahsknl38FPgjIdpZFg/nUPcj528q+HjLVL3Np72/tEW0NiQu+tLjb92IYbrXI4ke8aoh4xxQwxct9Fz8a7AwEir4vmLFtUm+fDaaGADIVoG3PYaosjM=
Message-ID: <a4e6962a0708230828h7346d747n55ff14a90d686ab1@mail.gmail.com>
Date: Thu, 23 Aug 2007 10:28:49 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "kernel list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 9p fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
 git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Mariusz Kozlowski (1):
    9p: fix bad error path in conversion routines

Adrian Bunk(2):
    9p: remove deprecated v9fs_fid_lookup_remove
    9p: fix use after free

Eric Van Hensbergen(1):
    9p: update maintainers and documentation

 Documentation/filesystems/9p.txt |   24 +++++++++++++++++++-----
 MAINTAINERS                      |    5 ++---
 fs/9p/fid.c                      |   17 -----------------
 fs/9p/fid.h                      |    2 --
 net/9p/conv.c                    |    2 +-
 net/9p/mux.c                     |   10 ++++++----
 6 files changed, 28 insertions(+), 32 deletions(-)
