Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXHHLEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXHHLEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXHHLEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:04:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:53177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXHHLEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:04:44 -0400
To: paul.pinault@disk91.com
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Data corruption
References: <200708072007.27343.paul.pinault@disk91.com>
	<46B906DD.5000501@redhat.com>
	<200708080831.10141.paul.pinault@disk91.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 13:59:04 +0200
In-Reply-To: <200708080831.10141.paul.pinault@disk91.com>
Message-ID: <p73lkcms0dz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

paul <paul.pinault@disk91.com> writes:

> Hi, thank you for your answer, actually I removed 2Gb of physical memory and 
> the problem gone away .. but my system needs 4Gb.
> 
> I reproduce it under Xen and without xen (on a standard kernel) I can't tell 
> you how mutch difference I have betwwen files, regarding a 4 month system 
> running on these condition, I think the number of errors are rare but 
> existing, during my tests with 100M files I did not get a lot of error, so we 
> can assume 2 or 3 bytes in error in 300M files... (expectation)

Does it work with iommu=nodac ? 

-Andi

