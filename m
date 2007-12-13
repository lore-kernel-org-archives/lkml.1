Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXLMPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXLMPon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbXLMPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:44:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33051 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXLMPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:44:35 -0500
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
From: Peter Zijlstra <peterz@infradead.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Osterried <osterried@jesse.de>
In-Reply-To: <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
	 <200709290614.02918.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0712021603060.26896@bizon.gios.gov.pl>
	 <200712030936.25363.osterried@jesse.de>
	 <Pine.LNX.4.64.0712131606410.24173@bizon.gios.gov.pl>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 16:44:31 +0100
Message-Id: <1197560671.6895.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 16:17 +0100, Krzysztof Oledzki wrote:
> 

> BTW: Could someone please look at this problem? I feel little ignored and 
> in my situation this is a critical regression.

I was hoping to get around to it today, but I guess tomorrow will have
to do :-/

So, its ext3, dirty some pages, sync, and dirty doesn't fall to 0,
right?

Does it happen with other filesystems as well?

What are you ext3 mount options?



