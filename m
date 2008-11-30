Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYK3ViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYK3ViT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYK3ViD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 16:38:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:45672 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbYK3ViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 16:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=m5H/w+ri431N0BZ2vO2vsZu5HOOCfM8hp/75aEIz/tgsnwdjgxXdIKYXQY8sgE3eLf
         CEl6xebGh1RQzTsQrMN5v+gfJLwXr5LoLHksYqcLnh6R3eptT5suElwbXnRGfExoGMCy
         1cHnzjEJqQsCgmkEyQnLmw6tIgAojqQAMzZWc=
Message-ID: <524f69650811301337uc02c4d4m96a28dcdb4112fd9@mail.gmail.com>
Date: Sun, 30 Nov 2008 15:37:52 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT] CIFS fix for problem with conversion from prepare_write to write_begin
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ed313489badef16d700f5a3be50e8fd8f8294bc8:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (1):
      [CIFS] fix regression in cifs_write_begin/cifs_write_end

 fs/cifs/file.c |   77 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 56 insertions(+), 21 deletions(-)


-- 
Thanks,

Steve
