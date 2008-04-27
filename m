Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYD0EzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYD0EzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYD0EzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:55:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58512
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYD0EzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:55:13 -0400
Date: Sat, 26 Apr 2008 21:55:13 -0700 (PDT)
Message-Id: <20080426.215513.141243565.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk
Subject: CONFIG_OPTIMIZE_INLINING
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, why the heck is this hiding under arch/x86/ and not in
lib/Kconfig.debug where it belongs?

    x86: add optimized inlining

If there are platforms that can't handle it, we can add a conditional
to lib/Kconfig.debug, but by default it should be made available
generically.

Where did this original patch get posted for review and discussion?

Tell me where!?!?!

The only references I see is where Stephen Rothwell complained that it
broke the powerpc build, and then on the git commit list when Linus
sucked this crud in.
