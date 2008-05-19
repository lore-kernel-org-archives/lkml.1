Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYESOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYESOnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYESOni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:43:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46671 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbYESOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:43:37 -0400
Message-ID: <483191F9.3010706@firstfloor.org>
Date: Mon, 19 May 2008 16:43:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080519231.561421028@firstfloor.org> <20080519123111.97C0C1B41FF@basil.firstfloor.org> <20080519140339.GB24267@infradead.org>
In-Reply-To: <20080519140339.GB24267@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd rather do a properly flag day and move lock_kernel into the
> instances instead of adding this _unlocked gunk.

I've considered that, but it's a bit too many fasync instances
all over the tree, so I chose this method.

-Andi

