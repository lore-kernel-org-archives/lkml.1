Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXISQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXISQKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758843AbXISQK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:10:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646AbXISQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:10:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] i386/PAE: avoid temporarily inconsistent pte-s
Date: Wed, 19 Sep 2007 18:09:47 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <46F150CB.76E4.0078.0@novell.com>
In-Reply-To: <46F150CB.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191809.47351.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 16:39:39 Jan Beulich wrote:
> One more of these issues (which were considered fixed a few releases
> back): Other than on x86-64, i386 allows set_fixmap() to replace
> already present mappings. Consequently, on PAE, care must be taken to
> not update the high half of a pte while the low half is still holding
> the old value.

Hmm perhaps it would be better to just forbid it on i386 too.
Do you know who uses it?

-Andi

