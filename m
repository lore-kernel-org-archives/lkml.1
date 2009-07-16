Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZGPEqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZGPEqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbZGPEqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:46:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47023 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZGPEqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:46:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090716133622.9D34.A69D9226@jp.fujitsu.com>
References: <20090715213516.9b47ad16.akpm@linux-foundation.org> <20090716133622.9D34.A69D9226@jp.fujitsu.com>
Message-Id: <20090716134535.9D37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 13:46:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, 16 Jul 2009 13:22:30 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > -#define __add_zone_page_state(__z, __i, __d)	\
> > > -		__mod_zone_page_state(__z, __i, __d)
> > > -#define __sub_zone_page_state(__z, __i, __d)	\
> > > -		__mod_zone_page_state(__z, __i,-(__d))
> > > -
> > 
> > yeah, whatever, I don't think they add a lot of value personally.
> > 
> > I guess they're a _bit_ clearer than doing __sub_zone_page_state() with
> > a negated argument.  Shrug.
> 
> OK, I've catched your point.
> I'll make all caller replacing patches.

Please drop last mail. I was confused ;-)


