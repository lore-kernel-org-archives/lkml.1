Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYA1Kd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYA1Kd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYA1Kdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:33:50 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:57119 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbYA1Kdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:33:49 -0500
Message-ID: <479DAF85.5020202@mev.co.uk>
Date: Mon, 28 Jan 2008 10:33:41 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH(v3) 2.6.24] Fix fakephp deadlock
References: <479A0D1C.8080401@mev.co.uk> <20080126220101.9e767f41.akpm@linux-foundation.org>
In-Reply-To: <20080126220101.9e767f41.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 10:33:41.0713 (UTC) FILETIME=[4052FC10:01C86199]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/08 06:01, Andrew Morton wrote:
> Adding a deferred-work like this just because we can't get the locking and
> refcounting correct is a really sad hack.

True, but some would argue that the fakephp driver itself was a really 
sad hack. :-)

> Can we get the locking and refcounting right please?  Start by making that
> wait-for-refcount-to-go-away go away.

I guess that stuff was added for a good reason and fixed other potential 
problems - it just broke fakephp.  It's an unusual requirement to try 
and support -- a file that self-destructs when you write to it.  Are 
there any other cases in sysfs that do that?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
