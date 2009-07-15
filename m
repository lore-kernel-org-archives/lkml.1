Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZGOPS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZGOPS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZGOPS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:18:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:23289 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZGOPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=roDbyU4cFklwdZl+lOZlbSjZc0ntPvgf6n7iUkwAFFm76peasXhfbjguHUF5xTeVpc
         zJCsNNzAELvFGApGIcp/t3IWs+5DHCGOVdI21N1Ndqi0M18gf54nM26lM7IGIOh5+ZqH
         hFqlylDI6Ljdh6Koxj4xFj5RPko3z3TbXFo74=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <davem@davemloft.net>
Cc: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ide-tape: misc stuff
Date: Wed, 15 Jul 2009 17:18:16 +0200
Message-Id: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

here is some ide-tape stuff.

* 0001: somehow fell through the cracks, DEBUG build fix

* 0002: mostly code unification

* 0003: this one converts ide-tape to the debugging scheme we use with ide-cd
  and ide-floppy. It adds some debug calls at important places and has proven
  very helpful when working on bug reports with users. No functional change.

* 0004: real bugfix

The patches are also at

	git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ide-tape-postponed


--
Thanks,
Boris.
