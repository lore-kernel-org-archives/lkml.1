Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbXFTWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbXFTWnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXFTWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:43:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbXFTWnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:43:39 -0400
Date: Wed, 20 Jun 2007 15:41:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <4679AAD5.4030604@redhat.com>
Message-ID: <alpine.LFD.0.98.0706201540580.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com> <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
 <4679AAD5.4030604@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Chuck Ebbert wrote:
> 
> Patch was just merged:

Well, that was the patch to make the conflict explicit, and just not 
allowing DEBUG_RODATA with KPROBES.

(And it has a "temporary" marker, which I actually think is wrong).

		Linus
