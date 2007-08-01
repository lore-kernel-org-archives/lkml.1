Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXHATYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXHATYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbXHATYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:24:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbXHATYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:24:38 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: smaller kernel with no real time futexes
Date: Wed, 1 Aug 2007 21:24:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708012124.34341.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

You said earlier you're looking at smaller allnoconfig kernels.
One thing I noticed recently that realtime pi futexes are always
enabled and that pulls in a lot of other code (like the plists) 

Userland needs to handle them not being available anyways for older
kernels.

Might be worth looking into turning that into a CONFIG.

-Andi
