Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbYESPNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbYESPNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYESPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:13:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYESPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:13:39 -0400
Message-ID: <48319901.2080809@firstfloor.org>
Date: Mon, 19 May 2008 17:13:05 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Trond.Myklebust@netapp.com, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/11] Remove BKL from remote_llseek
References: <20080519231.561421028@firstfloor.org> <20080519123110.930491B41FF@basil.firstfloor.org> <20080519140235.GA24267@infradead.org>
In-Reply-To: <20080519140235.GA24267@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Your new remote_llseek_unlocked is the same as generic_file_llseek
> except for the fact that it doesn't take i_mutex.  So I'd rather
> call it generic_file_llseek_nolock and make generic_file_llseek call
> it.  

Done. There's also default_llseek btw which is nearly similar, 
but i didn't touch that one.

> While you're at it you could also add some kerneldoc documents
> describing them.

Off topic for the series, left that to someone else.

-Andi


