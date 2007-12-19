Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbXLSFSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbXLSFSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXLSFSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:18:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXLSFSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:18:45 -0500
Date: Wed, 19 Dec 2007 14:17:53 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 10/20] SEQ replacement for anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
In-Reply-To: <20071218211549.536791435@redhat.com>
References: <20071218211539.250334036@redhat.com> <20071218211549.536791435@redhat.com>
Message-Id: <20071219140904.9858.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik-san,

> To keep the maximum amount of necessary work reasonable, we scale the
> active to inactive ratio with the size of memory, using the formula
> active:inactive ratio = sqrt(memory in GB * 10).

Great.

why do you think best formula is sqrt(GB*10)?
please tell me if you don't mind.

and i have a bit worry to it works well or not on small systems.
because it is indicate 1:1 ratio on less than 100MB memory system.
Do you think this viewpoint?


/kosaki

