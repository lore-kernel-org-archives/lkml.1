Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZHBMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZHBMuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZHBMux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:50:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47912 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZHBMuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:50:52 -0400
Date: Thu, 30 Jul 2009 11:07:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever
	possible when changing mapping
Message-ID: <20090730090747.GD1364@ucw.cz>
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248421981-31865-1-git-send-email-thellstrom@vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-24 09:53:01, Thomas Hellstrom wrote:
> The current code uses wbinvd() when the area to flush is > 4MB. Although this
> may be faster than using clflush() the effect of wbinvd() on irq
> latencies

You are slowing the kernel down, and you did not write down the
reasons. bad.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
