Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZELQkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZELQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZELQkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:40:23 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53462 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZELQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xOkaJukdnecC7i+w7COEkw3xSfBfmhlMWcmcKrdEISsHaoI17keL8q9F0ZcFO3E52a
         3io3XM8o7aG0vzuIQiAVhmQ2ClJ0a8SgSQpJ0mx1lmye3zpKLI3sduoxfaOnp61+Lwel
         Fy8nvxA8Vv80dyXB9fmlD11+GjGbRwCxpYL1M=
MIME-Version: 1.0
Date: Tue, 12 May 2009 20:40:20 +0400
Message-ID: <a4423d670905120940r5de3eab7v7e8e92d89107b962@mail.gmail.com>
Subject: 2.6.30-rc5: reiserfs is broken on parisc (bisected)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-parisc@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
       Al Viro <viro@zeniv.linux.org.uk>, reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

ab17c4f02156c4f75d7fa43a5aa2a7f942d47201 is the first bad commit
(reiserfs: fixup xattr_root caching)

Kernel panics when init tries to remount rootfs (reiserfs) with
read-write access.
Read-only access works fine.

No more messages on the screen before panic.

Is it endianess related?
