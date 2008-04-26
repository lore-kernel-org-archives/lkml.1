Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYDZJgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYDZJgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYDZJf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:35:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYDZJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:35:58 -0400
Date: Sat, 26 Apr 2008 05:35:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080426093553.GA17730@infradead.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F1F7A6.5020105@yandex.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 11:51:50AM +0300, Artem Bityutskiy wrote:
>> But these don't make much sense to me. Why would you want to be able
>> to compile out printks at this granularity? Why not enable all of them
>> when CONFIG_UBIFS_FS_DEBUG is enabled?
>
> Well, its just more convenient for us. If I know the bug is somewhere in
> the journal, I enable the journal messages - less flooding. We may
> lessen the amount, but it is still handy to have some classes of
> prints separate.

It's everything but convenient :)  Please make it one config option to
compile in all debug code and then have a module option to select the
verbosity level at runtime.

