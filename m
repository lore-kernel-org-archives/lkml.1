Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZA0Fwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZA0Fwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZA0FwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:52:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZA0FwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:52:10 -0500
Date: Tue, 27 Jan 2009 00:52:05 -0500
From: Kyle McMartin <kyle@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kyle McMartin <kyle@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
Message-ID: <20090127055205.GC5034@bombadil.infradead.org>
References: <20090126212918.d4770115.akpm@linux-foundation.org> <20090127053920.GB5034@bombadil.infradead.org> <20090128144316.D467.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128144316.D467.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 02:50:18PM +0900, KOSAKI Motohiro wrote:
> I think "char tcomm[sizeof(current->comm)];" is valid code.
> if checkpatch.pl don't warn "sizeof(current->comm)", I'm glad.
> 

Awfully interesting way of writing TASK_COMM_LEN :)

cheers, Kyle
