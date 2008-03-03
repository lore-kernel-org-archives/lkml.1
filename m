Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYCCHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYCCHOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYCCHOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:14:46 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51472 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYCCHOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:14:45 -0500
Date: Mon, 03 Mar 2008 16:14:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Cc: kosaki.motohiro@jp.fujitsu.com,
       "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>,
       "Rick van Rein" <rick@vanrein.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803031632.47888.nickpiggin@yahoo.com.au>
References: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com> <200803031632.47888.nickpiggin@yahoo.com.au>
Message-Id: <20080303161025.1E7E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > some architecture use PG_reserved for treat bad memory.
> > Why do you want introduce new page flag?
> > for show_mem() improvement?
> 
> I'd like to get rid of PG_reserved at some point. So I'd
> rather not overload it with more meanings ;)

really?

as far as I know, IA64 already use PG_reserved for bad memory.
please see arch/ia64/kernel/mcs_drv.c#mca_page_isolate.

Doesn't it works on ia64 if your patch introduce?


- kosaki


