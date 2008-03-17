Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYCQLvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYCQLvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYCQLvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:51:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58050 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYCQLvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:51:39 -0400
Date: Mon, 17 Mar 2008 20:51:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-ia64@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080317204810.7B4F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony-san,

seto-san teach me method of more investigate.
and I found the root cause is contained by following patch.

   [IA64] Multiple outstanding ptc.g instruction support


Could you please revert that patch from ia64?
I dislike its strong regression.

- kosaki

>     [IA64] cleanup and improve fsys_gettimeofday
>     [IA64] Multiple outstanding ptc.g instruction support
>     [IA64] VIRT_CPU_ACCOUNTING (accurate cpu time accounting)
> 
> unfortunately, I don't know how investigate more ;-)
> Please any suggestion.



