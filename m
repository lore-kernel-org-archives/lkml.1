Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYE2ET3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYE2ET3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYE2ETO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:19:14 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44281 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754135AbYE2ETK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:19:10 -0400
Date: Thu, 29 May 2008 13:17:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arch/sh: use __page_aligned_bss
Message-ID: <20080529041719.GB12619@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <483D82BB.8040005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483D82BB.8040005@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 05:05:15PM +0100, Jeremy Fitzhardinge wrote:
> The patch "make page-aligned data and bss less fragile" introduces
> __page_aligned_data and __page_aligned_bss to make sure that page
> aligned things remain so, even if there are non-page-sized
> page-aligned things.
> 
> This paragraph converts the two C instances of page-aligned bss
> variables to use them.  It's a purely decorative patch.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> 
If the first patch hits mainline then I'll take this directly in to my
tree, otherwise:

Acked-by: Paul Mundt <lethal@linux-sh.org>
