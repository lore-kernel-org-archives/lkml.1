Return-Path: <linux-kernel-owner+w=401wt.eu-S933448AbXBEUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbXBEUnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXBEUnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:43:21 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:46100 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbXBEUnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:43:19 -0500
Date: Mon, 5 Feb 2007 21:40:08 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Christoph Hellwig <hch@lst.de>
cc: akpm@osdl.org, haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
In-Reply-To: <20070205173247.GA25790@lst.de>
Message-ID: <Pine.LNX.4.61.0702052136310.19384@yvahk01.tjqt.qr>
References: <20070205173247.GA25790@lst.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 5 2007 18:32, Christoph Hellwig wrote:
>
>in two recent discussions (file_list_lock scalability and remount r/o
>on suspend) I stumbled over this emergency remount feature.  It's not
>actually useful because it tries a potentially dangerous remount
>despite writers still beeing in progress, which we can't get rid.

The current way is to remount things, and return -EROFS to any process
that attempts to write(). Unless we want to kill processes to get rid of
them [most likely we possibly won't], I am fine with how things are atm.
So, what's the "dangerous" part, actually?

>Any ideas and comments?

sysrq+u is helpful. It is like \( sysrq+s && make sure no further writes
go to disk \).



Jan
-- 
