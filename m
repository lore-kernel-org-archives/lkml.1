Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZHMHnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZHMHnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZHMHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:43:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZHMHnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:43:11 -0400
Subject: Re: Top shows cpu usage 165% with kvm lunched
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a8e1da0908121923j1fd291fbtb3576653ebd45bff@mail.gmail.com>
References: <a8e1da0908121923j1fd291fbtb3576653ebd45bff@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 09:42:46 +0200
Message-Id: <1250149366.10001.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 10:23 +0800, Dave Young wrote:
> Hi,
> 
> Kvm guest runs slackware-current, doing extracting linux tarball, top
> shows over 100% cpu usage. Is this a known issue?

Does: top -H, show the same?

I suspect it might be the cumulative cpu usage of several threads.
