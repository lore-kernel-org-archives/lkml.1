Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbXFUST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbXFUST3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXFUSTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:19:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682AbXFUSTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:19:22 -0400
Date: Thu, 21 Jun 2007 11:17:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches v2
In-Reply-To: <467AA8CA.2020206@googlemail.com>
Message-ID: <alpine.LFD.0.98.0706211115380.3593@woody.linux-foundation.org>
References: <467AA8CA.2020206@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Michal Piotrowski wrote:
> 
> Subject    : long freezes on thinkpad t60
> References : http://lkml.org/lkml/2007/5/24/100
> Submitter  : Miklos Szeredi <miklos@szeredi.hu>
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Patch      : http://lkml.org/lkml/2007/6/16/81
> Status     : patch was suggested

This one is fixed, and tested by Miklos. It's commit fa490cfd15: "Fix 
possible runqueue lock starvation in wait_task_inactive()".

			Linus
