Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYKKJI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYKKJI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 04:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYKKJIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 04:08:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:59991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYKKJIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 04:08:39 -0500
Message-ID: <49194B8F.80104@kernel.org>
Date: Tue, 11 Nov 2008 18:08:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: WARN_ON(ap->nr_active_links) in ata_eh_finish() with
 pata_ali DMA CD-ROM
References: <200811042128.10356.arvidjaar@mail.ru>
In-Reply-To: <200811042128.10356.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 11 Nov 2008 09:08:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Every now and then I give pata_ali CD-ROM DMA a test. This time I got
> someting new - not only usual timeouts but also WARN_ON. There was a
> whole bunch of subsequent WARN_ON's, but they are likely to be just
> followup errors.
> 
> Also, in the past ejecting media from drive would abort processing and
> all commands waiting for completion would return to prompt. Now they
> seem to hang forever.

The next -rc should fix this.  Thanks.

-- 
tejun
