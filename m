Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXCaVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXCaVFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXCaVFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:05:32 -0400
Received: from gw.goop.org ([64.81.55.164]:39542 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXCaVFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:05:31 -0400
Message-ID: <460ECD13.4000603@goop.org>
Date: Sat, 31 Mar 2007 14:05:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [2.6 patch] remove the config option for the cs5530a_warm_reset()
 quirk
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331205530.GZ14134@stusta.de>
In-Reply-To: <20070331205530.GZ14134@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Instead of cleaning up this mess, please replace this patch with the 
> patch below.
>   

Yeah, I considered that patch as a placeholder; I'd been wondering if it
can be completely removed.

But this patch looks fine, though I'd go further - the lookup table of
pci ids is overkill since it only has one entry (and doesn't look likely
to grow any more).

    J
