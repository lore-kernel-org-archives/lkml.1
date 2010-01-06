Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372Ab0AFFc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0AFFc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 00:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996Ab0AFFc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 00:32:26 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:63401 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0AFFcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 00:32:25 -0500
From: Miles Bader <miles@gnu.org>
To: linux-kernel@vger.kernel.org
Subject: tools/perf: "perf record" restricted to root in latest kernel?
Reply-To: Miles Bader <miles@gnu.org>
System-Type: x86_64-unknown-linux-gnu
Blat: Foop
Date: Wed, 06 Jan 2010 14:32:17 +0900
Message-ID: <buopr5nol26.fsf@dhlpc061.dev.necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried compiling tools/perf in an old linux source tree (ab86e5765,
roughly 2.6.31), and the resulting perf tool seemed to work fine
("perf record" ... "perf report", "perf stat" etc); I ran it as an
ordinary user.

Next I updated to the latest linus tree (c5974b835a), and recompiled perf.
It still seems to work, and has obviously had a lot of features added, but
now it only wants to let me run "perf record" if I'm root.  This is
slightly annoying -- even if I use "sudo" or make it setuid, it still ends
up generating an output file owned by root, etc.

In both cases, I'm using the same kernel (I only recompiled the tool), 2.6.32.

I used no options with "perf record", just gave the command I wanted to profile.

Is there a reason why the newer version perf tool restricts "perf record"
to root, especially given that the older version still seems to work fine
as non-root?

Thanks,

-Miles

-- 
Run away!  Run away!
