Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbXINXUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbXINXUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbXINXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:20:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbXINXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:20:11 -0400
Subject: Re: [PATCH] Configurable reclaim batch size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709141519230.14894@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 01:20:02 +0200
Message-Id: <1189812002.5826.31.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-14 at 15:23 -0700, Christoph Lameter wrote:
> This patch allows a configuration of the basic reclaim unit for reclaim in 
> vmscan.c. As memory sizes increase so will the frequency of running 
> reclaim. Configuring the reclaim unit higher will reduce the number of 
> times reclaim has to be entered and reduce the number of times that the 
> zone locks have to be taken.

It increases the lock hold times though. Otoh it might work out with the
lock placement.

Do you have any numbers that show this is worthwhile?



