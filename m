Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZJaJod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZJaJod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZJaJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:44:32 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50387 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbZJaJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZWXuW0boeH6QF9wT3c6GRyUUbqgJdaflr5XX4PppETEUcxAJXbtVmwJFRQwAwZG818
         R/kxXhyziy63O6IwNH46ZqqPKDJhJEuuxVFjIdJjkTdEGPmYnHRQr9Uncux8PuOY4GQ2
         oDzsMCcVKVPRRiCLHyurFv9JgRMsiloquxvQs=
Date: Sat, 31 Oct 2009 12:44:31 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, apicdef: Fix checkpatch issues in apicdef.h
Message-ID: <20091031094431.GB4869@lenovo>
References: <b9df5fa10910310229s2d9f85c1y31403ecbf8c31567@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10910310229s2d9f85c1y31403ecbf8c31567@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rakib Mullick - Sat, Oct 31, 2009 at 03:29:32PM +0600]
|
|  In apicdef.h - we have a checkpatch issue - needs to be fixed.
| We were warned by the following checkpatch warning:
| 
| ERROR: space prohibited before that ':' (ctx:WxW)
| #276: FILE: arch/x86/include/asm/apicdef.h:376:
| +                       hi      : 1;
|                                 ^
| ---
| Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
| 

Hi Rakib,

personally I would not change it even having checkpatch
issue. Really, it's easier to read this bitfield width
aligned rather then moved left. But this is a personal
opinion only (sorry).

	-- Cyrill
