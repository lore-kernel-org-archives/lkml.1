Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZE1ITC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZE1ITC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZE1ISp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:18:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36950 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZE1ISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:18:44 -0400
Date: Thu, 28 May 2009 10:18:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
       Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 00/19] periodic write-back timer optimization
Message-ID: <20090528081845.GU11363@kernel.dk>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain> <200905271323.29818.arnd@arndb.de> <4A1D31BA.6060903@nokia.com> <20090527123320.GF11363@kernel.dk> <4A1D3418.8060909@nokia.com> <20090527124719.GH11363@kernel.dk> <4A1E307B.1060807@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1E307B.1060807@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28 2009, Artem Bityutskiy wrote:
> Jens Axboe wrote:
>> That would be great, I would have no problem integrating such a feature.
>> It definitely makes sense.
>
> Hi Al, Christoph,
>
> unless you have objections against the whole idea, I wonder if
> it would be possible to make the patches which wrap sb->s_dirt
> usage go via VFS tree first, and then I'd continue the timer
> optimization work separately. IMO, wrapping s_dirt makes sense
> in general. I mean, patches 01-17 from this series.

That makese sense, those are totally separate from the actual
functionality.

-- 
Jens Axboe

