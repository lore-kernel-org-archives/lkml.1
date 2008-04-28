Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbYD1NC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbYD1NC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765480AbYD1NCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:02:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47626 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765277AbYD1NCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:02:50 -0400
Date: Mon, 28 Apr 2008 09:02:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind@yandex.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Message-ID: <20080428130245.GA2798@infradead.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <20080426093553.GA17730@infradead.org> <48157812.5090909@nokia.com> <20080428090032.GA14100@infradead.org> <4815B3AE.5010500@nokia.com> <20080428113932.GA27250@infradead.org> <4815C239.5050800@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4815C239.5050800@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 03:25:29PM +0300, Adrian Hunter wrote:
> At one stage Artem had set up sysfs entries for UBIFS so that he could change
> debugging options via sysfs on the fly, without even unmounting.  But he said
> he didn't find it that useful and removed it all.
>
> For myself, recompiling UBIFS only takes 25 seconds so changing config options
> is not a big deal.
>
> However I have no problem adding a mount option, although I suspect we might
> end up being asked to remove it.

module_param is probably easier and more useful, that way it can be set
at module load/boot time and be changed later in sysfs.
