Return-Path: <linux-kernel-owner+w=401wt.eu-S1765982AbYDOVgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765982AbYDOVgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYDOVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:35:54 -0400
Received: from waste.org ([66.93.16.53]:50280 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbYDOVfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:35:53 -0400
Subject: Re: [PATCH v2] mm: Fix possible off-by-one in walk_pte_range()
From: Matt Mackall <mpm@selenic.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, LKML <linux-kernel@vger.kernel.org>,
       Roel Kluin <12o3l@tiscali.nl>, Andreas Schwab <schwab@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <8763ujhz4a.fsf_-_@saeurebad.de>
References: <12082680403770-git-send-email-hannes@saeurebad.de>
	 <18436.52094.242415.163660@harpo.it.uu.se> <8763ujhz4a.fsf_-_@saeurebad.de>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 14:34:56 -0700
Message-Id: <1208295296.616.1.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 18:16 +0200, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@saeurebad.de>
> Subject: [PATCH] mm: Fix possible off-by-one in walk_pte_range()
> 
> After the loop in walk_pte_range() pte might point to the first address
> after the pmd it walks.  The pte_unmap() is then applied to something
> bad.
> 
> Spotted by Roel Kluin and Andreas Schwab.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

