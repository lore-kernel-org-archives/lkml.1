Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178Ab0AZWpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0AZWpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164Ab0AZWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:45:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48946 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0AZWpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EZesL6evMLa/uf7wyDuD9f/xWlN3VxcMSZlzLH4cQmrzL3Ep8cnzefoxn1uEKUJwNP
         1VfCnDnT7E+qOG3I4mUS6bhRKPrKpl527kwvWs+jd+qekdYcmFZPmfeXH3/ZmaWs5U+B
         6ybnUOuyQmS+8hEQSPDZOameZBgrZqazD0zXQ=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 16:44:59 -0600
Message-ID: <a4e6962a1001261444l1235a15dxada6964151ffe119@mail.gmail.com>
Subject: [GIT PULL] 9p file system bug fixes
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

  Please pull a couple of bug fixes for the 9P filesystem for 2.6.33-rc

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
  Linus Torvalds (1):
        Linux 2.6.33-rc4

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Eric Van Hensbergen (3):
      net/9p: fix virtio transport to correctly update status on connect
      net/9p: fail when user specifies a transport which we can't find
      net/9p: fix statsize inside twstat

 net/9p/client.c       |   13 +++++++++++--
 net/9p/trans_virtio.c |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

      Thanks,

           -eric
