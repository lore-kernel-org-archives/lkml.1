Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbXGRQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbXGRQpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934649AbXGRQoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:44:21 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44799 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934370AbXGRQoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:44:20 -0400
From: "Paul Moore" <paul.moore@hp.com>
Message-Id: <20070718162844.912864704@hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 18 Jul 2007 12:28:44 -0400
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, torvalds@linux-foundation.org,
       michal.k.k.piotrowski@gmail.com
Subject: [PATCH v3 0/2] The comedy of errors patchset (was: SELinux NetLabel updates)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This rev of the patchset solves both the original problem that Michal posted
involving backwards compatibility with old SELinux policy as well as the
problem Linus posted about the fix not working correctly when CONFIG_NETLABEL
was not set.  I also tried to fixup the #ifdefs in include/net/netlabel.h as
suggested.

I've tested both of these patches, in order, and neither have caused problems
(i.e. there shouldn't be any git bisect breakage issues if only the first
patch is applied).  I've also compiled both patches with and without
CONFIG_NETLABEL and have not seen any problems.

Once again, thank you all for your patience.

-- 
paul moore
linux security @ hp
