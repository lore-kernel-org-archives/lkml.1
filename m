Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbYLLJfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbYLLJfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYLLJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:35:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59370 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbYLLJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:35:27 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [regression] uml is very slow on 2.6.28 host
Message-Id: <E1LB4QO-0005fk-7g@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 12 Dec 2008 10:35:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the UML boot gets to the userspace part it gets really really
slow.  It takes about 20 times the normal time to fully boot.  CPU
seems to be idle.

Guest version doesn't matter.  Host version 2.6.27 was OK, latest git
is not OK.  I'm running 32bit guest on 64bit host.

Anyone else experiencing this?

Thanks,
Miklos
