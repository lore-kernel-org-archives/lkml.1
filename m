Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZIYWJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZIYWJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIYWJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:09:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18334 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZIYWJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=e9l04Zoa/MLi+VHwKzXSfblUkCgysL/kGYsFfBxa+ivRebDbxarHh4Lc3D/Z7h8cna
         yo+bNheDASKKlPB2k8i0MKZXd5rOh0Uyw+OmgUfqfqTQqSzuTNPfwZHeNAYyvCQqh6W2
         GVc5GoP9I4L0JvVtDb71MlGkUkIAtIC+Zy7TQ=
MIME-Version: 1.0
Date: Fri, 25 Sep 2009 23:09:32 +0100
Message-ID: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
Subject: Regression: kernels since 2.6.26 are unusably slow
From: Aneurin Price <aneurin.price@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Every kernel since 2.6.26 has been unusably slow for me - to the extent that I
initially thought they were hanging on boot. Exactly how bad it is seems to
vary, but it could take several minutes to boot, and then another minute or two
to log in (with bash pegging the CPU as it loads). Everything seems to need
vastly more CPU time than usual - it feels a little like I'm using a 486.

I've bisected the problem down to commit
42651f15824d003e8357693ab72c4dbb3e280836 (x86: fix trimming e820 with MTRR
holes). Having basically no idea what that means, I thought I'd try building a
kernel with MTRRs disabled, to see if that would make any difference, but no
joy.

Can anyone give me some idea of where to go next, or let me know what further
information I should provide?

Thanks,
Nye
