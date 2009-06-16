Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZFPRZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZFPRZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZFPRZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:25:03 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:7593 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbZFPRZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:25:03 -0400
Message-Id: <6.2.5.6.2.20090616132304.05a7f490@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 16 Jun 2009 13:24:27 -0400
To: Mel Gorman <mel@csn.ul.ie>
From: starlight@binnacle.cx
Subject: Re: QUESTION: can netdev_alloc_skb() errors be reduced
  by tuning?
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Tried increasing a few /proc/slabinfo tuneable parameters today
>and this appears to have fixed the issue so far today.

Spoke too soon.  A burst of allocation fails appeared
a some incoming data was lost.  'e1000e' system had
no problem.

