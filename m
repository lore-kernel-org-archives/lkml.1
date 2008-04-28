Return-Path: <linux-kernel-owner+w=401wt.eu-S1765575AbYD1JAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765575AbYD1JAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYD1JAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:00:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYD1JAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:00:40 -0400
Date: Mon, 28 Apr 2008 05:00:32 -0400
From: ext Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: ext Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080428090032.GA14100@infradead.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org> <48157812.5090909@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48157812.5090909@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:09:06AM +0300, Adrian Hunter wrote:
>> It's everything but convenient :)  Please make it one config option to
>> compile in all debug code and then have a module option to select the
>> verbosity level at runtime.
>
> Surely that judgement should be made by people who actually debug UBIFS.

I've debugged enough code including filesystems far more complex than
ubifs so you can happily trust my judgement.  Even if not you can simply
switch on your brain and notice that a runtime/boottime switch is always
more convenient than a compile-time switch, and the only reason against
it would be a performance penalty.
