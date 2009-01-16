Return-Path: <linux-kernel-owner+w=401wt.eu-S937539AbZAPVm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937539AbZAPVm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762284AbZAPVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:42:45 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:35599 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZAPVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:42:44 -0500
Message-ID: <4970FFB9.2060006@gmail.com>
Date: Sat, 17 Jan 2009 00:44:25 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Reiserfs mailing list <reiserfs-devel@vger.kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?Mathieu_B=E9langer?= <b747xx@gmail.com>
Subject: Reiser4progs-1.0.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

Changes since reiser4progs-1.0.6:

. Fixed bug in fsck reported by Mathieu Bélanger
  (incorrect checking compressed file bodies);
. Alias -p "preen" to -a "auto" for fsck options;
. Suppressed per-object fsck reports about wrong bytes for
  files with data checksumming. Use fsck option --fix to
  set up their correct values (in the case of transparent
  compression i_blocks and i_bytes are not supported
  by kernel for performance reasons). If bytes are wrong
  because of fatal corruptions, then fsck will report about
  last ones.

All the patches were announced at reiserfs-devel mailing list.
Please, find at
http://www.kernel.org/pub/linux/utils/fs/reiser4/reiser4progs/

Thanks,
Edward.

