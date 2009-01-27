Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZA0FTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZA0FTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZA0FTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:19:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZA0FTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:19:33 -0500
Date: Tue, 27 Jan 2009 00:19:19 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] export get_task_comm()
Message-ID: <20090127051919.GA5034@bombadil.infradead.org>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126211655.c7287768.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 09:16:55PM -0800, Andrew Morton wrote:
> Ho hum, I suppose so.  I redid the changelog a bit:
> 
>    task_struct.comm[] is useful for debugging and driver developers
>    want to use this information easily.  Direct access to
>    task_struct.comm[] is a bit racy, so export the official accessor.
> 

Maybe lirc should be submitted to staging/ before we go exporting
symbols for out of tree things... ;-)

