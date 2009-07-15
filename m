Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbZGOEfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbZGOEfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZGOEfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:35:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35453 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZGOEfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:35:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jul 2009 13:33:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Message-Id: <20090715133324.e4683ef2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090715040811.GF24034@balbir.in.ibm.com>
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
	<20090715040811.GF24034@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 09:38:11 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-07-10 18:29:50]:
> 
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > New Feature: Soft limits for memory resource controller.
> > 
> > Here is v9 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. The CPU controllers interpretation
> > of shares is very different though. 
> >
> 
> If there are no objections to these patches, could we pick them up for
> testing in mmotm. 
> 

If any, will be fixed up in mmotm. About behavior, I don't have more things
than I've said. (dealying kswapd is not very good.)

But plz discuss with Vladislav Buzov about implementation details of [2..3/5].
==
[PATCH 1/2] Resource usage threshold notification addition to res_counter (v3)

It seems there are multiple functionalities you can shere with them.

 - hierarchical threshold check
 - callback or notify agaisnt threshold.
 etc..

I'm very happy if all messy things around res_counter+hierarchy are sorted out
before diving into melting pot. I hope both of you have nice interfaces and
keep res_counter neat.

Thanks,
-Kame

