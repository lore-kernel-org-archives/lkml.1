Return-Path: <linux-kernel-owner+w=401wt.eu-S1031143AbXEAIms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031143AbXEAIms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031597AbXEAIms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:42:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38150 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031143AbXEAImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:42:47 -0400
Date: Tue, 1 May 2007 09:42:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: "partical" kthread conversion
Message-ID: <20070501084245.GA14364@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ebiederm@xmission.com
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430162007.ad46e153.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 04:20:07PM -0700, Andrew Morton wrote:
>  macintosh-mediabay-convert-to-kthread-api.patch
>  macintosh-adb-convert-to-the-kthread-api.patch
>  macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
>  powerpc-pseries-rtasd-convert-to-kthread-api.patch
>  powerpc-pseries-eeh-convert-to-kthread-api.patch
> 
> Will send to paulus (I already did - does Paul not handle the macintosh
> driver?)

Please don't send out the partial kthread conversions, as they're not
that helpful.  Depending on the way we'll let the API evolve a
kthread_create/run not paired by a kthread_stop might be actually harmful.

Please only send along patches that are paired or always built in so that
they don't require stopping at all.

Btw, many of the drivers above should probably go to benh.

There's probably a few more patches falling into this category, these
were just the first one the stick into my eye.
