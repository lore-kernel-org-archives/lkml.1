Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbXH3RHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbXH3RHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXH3RHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:07:10 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39840 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbXH3RHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:07:09 -0400
Date: Thu, 30 Aug 2007 19:07:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Clemens Kolbitsch <clemens.kol@gmx.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
In-Reply-To: <200708301844.10532.clemens.kol@gmx.at>
Message-ID: <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz>
References: <200708301844.10532.clemens.kol@gmx.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:

> It all works perfectly well (creating & deleting the additional 
> mappings), however, when the kernel feels like it needs to allocate a 
> mapping in user-space it sometimes deletes my mapping and overwrites it 
> with the new one, although there is plenty of free memory at some other 
> location.

Hi Clemens,

what do you mean by "overwrites it"? It just probably merges your vma with 
the newly created one, right?

-- 
Jiri Kosina
