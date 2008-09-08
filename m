Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYIHOrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYIHOrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYIHOre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:47:34 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44375 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYIHOrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:47:33 -0400
Date: Mon, 8 Sep 2008 15:45:59 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Paulo Marques <pmarques@grupopie.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: -mm: please drop h8300 kallsyms patch
Message-ID: <Pine.LNX.4.64.0809081521270.19968@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop h8300-kallsyms-exclude-local-symbols.patch from mm for now.

I'm all in favour of its intent, cutting local .Lfoo symbols out of the
the symbol table.  But at present it's cutting out all .symbols - which
is very unfriendly to powerpc, whose every function is a .symbol!
The undotted symbol being the descriptor that points to the function.

My 2.6.27-rc5 powerpc System.map doesn't actually contain any .Lsymbols,
but I expect someone else's does: I doubt excluding .Lsymbols is the
right answer, though it would be an improvement.

Maybe Paulo or Sam has a grasp on what the different architectures'
toolchains do, and can suggest the right patch.

Thanks,
Hugh
