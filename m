Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbXH3VfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbXH3VfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbXH3Ve5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:34:57 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60906 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760302AbXH3Ve4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:34:56 -0400
Date: Thu, 30 Aug 2007 23:34:52 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Clemens Kolbitsch <clemens.kol@gmx.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
In-Reply-To: <200708302332.42744.clemens.kol@gmx.at>
Message-ID: <Pine.LNX.4.64.0708302333320.2460@twin.jikos.cz>
References: <200708301844.10532.clemens.kol@gmx.at>
 <Pine.LNX.4.64.0708301906020.2460@twin.jikos.cz> <200708302332.42744.clemens.kol@gmx.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:

> is there no way to tell the kernel, that a certain mapping must not be 
> removed, no matter what (except of course an explicit call to sys_unmap, 
> of course)?

I don't seem to get what is the issue here. Your mapping is not removed, 
only the VMAs are merged together into one larger VMA if they have 
neighbouring address ranges and compatible protection bits. See 
vma_merge().

-- 
Jiri Kosina
