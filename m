Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZGRJzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZGRJzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZGRJzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:55:24 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:55470 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZGRJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SVoG4nHKE/06bxSciZ0MxDgrEtNR770rvoUD6JMCqkH23DU/KY+CTyJTsWI+Jahm4W
         sylMdfiWOBaNDnXsPgqV5jtMejtvgkOt8OsZ0l8rD3al+NVOyeSwERk611etMbT2qlyE
         jKSHdWHT1DWS4mW7WaqYzKjUZ9BEYP8TGeb0g=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ide-tape: misc stuff
Date: Sat, 18 Jul 2009 11:55:14 +0200
Message-Id: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

here's a re-spun version with patch 2 dropped.

* 0001: somehow fell through the cracks, DEBUG build fix

* 0002: this one converts ide-tape to the debugging scheme we use with ide-cd
  and ide-floppy. It adds some debug calls at important places and has proven
  very helpful when working on bug reports with users. No functional change.

* 0003: real bugfix

The patches are also at

	git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ide-tape-postponed


--
Thanks,
Boris.
