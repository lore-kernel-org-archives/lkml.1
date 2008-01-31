Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYAaBSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYAaBSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYAaBSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:18:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54810 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYAaBSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:18:11 -0500
Date: Thu, 31 Jan 2008 10:17:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1201703382.5459.3.camel@localhost>
References: <20080130175439.1AFD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1201703382.5459.3.camel@localhost>
Message-Id: <20080131100838.1F3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee-san

> Rik is currently out on holiday and I've been traveling.  Just getting
> back to rebasing to 24-rc8-mm1.  Thank you for your efforts in testing
> and tracking down the regressions.  I will add your fixes into my tree
> and try them out and let you know.  Rik mentioned to me that he has a
> fix for the "get_scan_ratio()" calculation that is causing us to OOM
> kill prematurely--i.e., when we still have lots of swap space to evict
> swappable anon.  I don't know if it's similar to what you have posted.
> Have to wait and see what he says.  Meantime, we'll try your patches.

thank you for your quick response.

on my test environment, my patch solve incorrect OOM.
because, too small reclaim cause OOM.

Please confirm.


- kosaki


