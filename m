Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbYACQBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbYACQBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYACQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:01:15 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:33135 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYACQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:01:15 -0500
Message-ID: <477D0694.1010005@s5r6.in-berlin.de>
Date: Thu, 03 Jan 2008 17:00:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: New branch for +1 kernel Was:Re: [PATCH] Use __u64 in aligned_u64's
 definition
References: <4d8e3fd30801021441h51f180des465f94ed24b107c2@mail.gmail.com>
In-Reply-To: <4d8e3fd30801021441h51f180des465f94ed24b107c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi wrote:
> This is something i was thinking to suggest.
> Kernel is made of a lot of different "areas" and the regression list
> is a great tool for monitoring every single area so why not opening a
> new branch and accepting patches only for areas which are not in the
> current regression list.?

Some regressions can't be easily associated with an "area".  And when
they can, consider the overhead involved with frequently kicking out
patchsets and taking them in again, based on when regressions become
known and when they are fixed, respectively.

> Sounds like a good way to be more strict about regressions and
> incentive people to solve regressions quicker.

To create such a motivation, that branch or tree would have to have a
practical use in development.  So what purpose would such a tree
fulfill, considering that we already have a myriad of topic trees and
the -mm tree for testing and preintegration?
-- 
Stefan Richter
-=====-==--- ---= ---==
http://arcgraph.de/sr/
