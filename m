Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYKTUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYKTUTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKTUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:19:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:39933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYKTUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gjLKrNfiyIwmrFnrEDp9PDgM6bj3Q5608kZADwRd+jgfv5FtwykN/JDx51FV+bPBuR
         jtL5yendpYEFXWQLZsmA1dBEKbEExkPk9bF9ltPhhenmKia5WQSEj7f0ORa4WuYLsBH8
         2cDkFfkcfzJbdlF+3f0X/1YJFbj3q9oQO5n0I=
Message-ID: <524f69650811201219t38f8a026h91a0504e44bf956@mail.gmail.com>
Date: Thu, 20 Nov 2008 14:19:33 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT] CIFS Fixes
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4e14e833ac3b97a4aa8803eea49f899adc5bb5f4:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Steve French (2):
      [CIFS] fix check for dead tcon in smb_init
      [CIFS] Do not attempt to close invalidated file handles

 fs/cifs/CHANGES    |    6 +++++-
 fs/cifs/cifsglob.h |   10 +++++++++-
 fs/cifs/cifssmb.c  |    2 +-
 fs/cifs/file.c     |   21 ++++++++++++++-------
 fs/cifs/misc.c     |    3 +++
 fs/cifs/readdir.c  |    5 ++++-
 6 files changed, 36 insertions(+), 11 deletions(-)


-- 
Thanks,

Steve
