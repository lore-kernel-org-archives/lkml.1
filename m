Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbYCCJtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbYCCJtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:49:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYCCJs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:48:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46811 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYCCJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:48:56 -0500
Date: Mon, 03 Mar 2008 18:49:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Cc: kosaki.motohiro@jp.fujitsu.com,
       "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Rick van Rein" <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803031835.03082.nickpiggin@yahoo.com.au>
References: <20080303161025.1E7E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <200803031835.03082.nickpiggin@yahoo.com.au>
Message-Id: <20080303184453.1E8C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > as far as I know, IA64 already use PG_reserved for bad memory.
> > please see arch/ia64/kernel/mcs_drv.c#mca_page_isolate.
> >
> > Doesn't it works on ia64 if your patch introduce?
> 
> It doesn't really need to use PG_reserved there, no. It could
> use PG_bad for that instead.

unfortunately that feature already merged to mainline.
and i am not its developer, sorry ;)

- kosaki


