Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYLKGrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYLKGrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYLKGqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:46:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36426 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYLKGqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:46:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
In-Reply-To: <4940B426.6040509@hitachi.com>
References: <4940B426.6040509@hitachi.com>
Message-Id: <20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 15:46:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> This patch introduces new kernel parameter `coredump_filter'.
> Setting a value to this parameter causes the default bitmask
> of coredump_filter to be changed.
> 
> It is useful for users to change coredump_filter settings for
> the whole system at boot time.  Without this parameter, users
> have to change coredump_filter settings for each /proc/<pid>/
> in an initializing script.

I think this patch only useful on following situation, right?

  - Administrator can't change rc script.
  - Administrator can change boot parameter.


When happen above situation?
or, you intent to init process debugging?


