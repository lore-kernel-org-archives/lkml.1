Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZCTIxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZCTIxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZCTIwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:52:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:34113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbZCTIwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:52:50 -0400
Subject: Re: question about pt locking
From: Peter Zijlstra <peterz@infradead.org>
To: Shentino <shentino@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090320081633.GA673@shentino-desktop>
References: <20090320081633.GA673@shentino-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 09:52:10 +0100
Message-Id: <1237539130.24626.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 01:16 -0700, Shentino wrote:
> Just curious, but does a process effectively have a read-lock on its 
> page tables when it's in userland?

No, page reclaim can fiddle with a running process' page tables
concurrently.
