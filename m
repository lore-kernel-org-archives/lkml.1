Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYAQMWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYAQMWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYAQMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:22:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50400 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYAQMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:22:29 -0500
Date: Thu, 17 Jan 2008 21:22:50 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: CaT <cat@zip.com.au>
Subject: Re: 2.6.24-rc7: memory leak?
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080117121408.GS3940@zip.com.au>
References: <1200571632.28661.13.camel@twins> <20080117121408.GS3940@zip.com.au>
Message-Id: <20080117212142.11EC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > Should all this cache usage not be counted towards the
> > > 'Cached' entry in meminfo rather then getting counted as part of used
> > > ram. 
> > 
> > Cached is only the page-cache, not all the other caches we have..
> > This someones confuses people, but one gets used to it. slabinfo allows
> > one to easily view others.
> 
> So what would I have to do to find out the real amount of memory free?
> Would that be the MemFree field in /proc/meminfo plus, from
> /proc/slabinfo, *_cache and size-*?

SReclaimable field can't fill requilrement? :)


-kosaki


