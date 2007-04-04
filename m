Return-Path: <linux-kernel-owner+w=401wt.eu-S2992774AbXDDJVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992774AbXDDJVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992780AbXDDJVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:21:51 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41571 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992774AbXDDJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:21:50 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl
In-reply-to: <20070403144224.227434440@taijtu.programming.kicks-ass.net>
	(message from Peter Zijlstra on Tue, 03 Apr 2007 16:40:48 +0200)
Subject: Re: [PATCH 1/6] mm: scalable bdi statistics counters.
References: <20070403144047.073283598@taijtu.programming.kicks-ass.net> <20070403144224.227434440@taijtu.programming.kicks-ass.net>
Message-Id: <E1HZ1fn-0005oT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Apr 2007 11:20:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Provide scalable per backing_dev_info statistics counters modeled on the ZVC
> code.

Why do we need global_bdi_stat()?  It should give approximately the
same numbers as global_page_state(), no?

Thanks,
Miklos
