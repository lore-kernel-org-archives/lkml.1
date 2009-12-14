Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZLNMkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZLNMkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZLNMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:40:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35504 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZLNMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:40:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214213932.BBC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:40:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw, following is mesurement result by hackbench.
> ================
> 
> unit: sec
> 
> parameter			old		new
> 130 (5200 processes)		5.463		4.442
> 140 (5600 processes)		479.357		7.792
> 150 (6000 processes)		729.640		20.529

old mean mmotm1208
new mean mmotm1208 + Rik patch + my patch



