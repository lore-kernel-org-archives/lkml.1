Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYDPHQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYDPHQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYDPHQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:16:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYDPHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:16:41 -0400
Message-ID: <4805A798.7050004@firstfloor.org>
Date: Wed, 16 Apr 2008 09:15:36 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Markus Metzger <markus.t.metzger@intel.com>, andi-suse@firstfloor.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 1/1] x86, ptrace: PEBS support
References: <20080408110158.A9336@sedona.ch.intel.com> <20080415173534.b746f8da.akpm@linux-foundation.org>
In-Reply-To: <20080415173534.b746f8da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Should we skip the RLIMIT_MEMLOCK check if capable(CAP_IPC_LOCK)?

FWIW I don't think we should. They are not really related.

> It's a fairly large patch.

The original version was much smaller -- a lot of the increase came out of
review feedback for "more infrastructure" etc. I don't think you can blame
Markus for that.

-Andi
