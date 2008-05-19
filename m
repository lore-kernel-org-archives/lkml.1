Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYESPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYESPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYESPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:46:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49186 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYESPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:46:12 -0400
Message-ID: <4831A09F.8090300@firstfloor.org>
Date: Mon, 19 May 2008 17:45:35 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, corbet@lwn.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080519231.561421028@firstfloor.org>	<20080519123111.97C0C1B41FF@basil.firstfloor.org>	<20080519140339.GB24267@infradead.org>	<483191F9.3010706@firstfloor.org>	<20080519161224.030b82c3@core>	<48319CC2.705@firstfloor.org> <20080519162206.18949d0b@core>
In-Reply-To: <20080519162206.18949d0b@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The good news is that none of them I looked at actually needed BKL
>> (or perhaps I just missed it)
> 
> Far better to send an initial patch that simply adds all the lock/unlocks
> then remove them later than worry about it immediately - that makes it
> easier to verify changes and to do testing

I fail to see how that makes it easier than with ->fasync_unlocked.

-Andi

