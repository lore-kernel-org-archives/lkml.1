Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbZFWLF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbZFWLF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZFWLFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:05:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45922
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758209AbZFWLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:05:47 -0400
Date: Tue, 23 Jun 2009 04:05:51 -0700 (PDT)
Message-Id: <20090623.040551.37741458.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: acme@redhat.com, mel@csn.ul.ie, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
 from DCCP
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A40B69A.2020703@gmail.com>
References: <20090623023936.GA2721@ghostprotocols.net>
	<20090622.211927.245716932.davem@davemloft.net>
	<4A40B69A.2020703@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 23 Jun 2009 13:03:54 +0200

> But it has some bootmem references, it might need more work than
> just exporting it.

In that case we should probably just apply the original patch
for now, and leave this cleanup as a future change.
