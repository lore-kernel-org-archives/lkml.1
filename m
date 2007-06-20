Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXFTWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXFTWlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXFTWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:41:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:43326 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbXFTWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:41:42 -0400
Message-ID: <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com>
Date: Thu, 21 Jun 2007 10:41:41 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, "Ingo Molnar" <mingo@elte.hu>,
       "Darrick J. Wong" <djwong@us.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Bj?rn Steinbrink" <B.Steinbrink@gmx.de>,
       "William Cohen" <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       "Antonino Daplas" <adaplas@gmail.com>, "Olaf Hering" <olaf@aepfle.de>,
       "Ville Syrj?l?" <syrjala@sci.fi>, "Jean Delvare" <khali@linux-fr.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Soeren Sonnenburg" <kernel@nn7.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Well, for 2.6.22, Kprobes will just be disabled if you use DEBUG_RODATA.
>
> And yes, that patch already got merged. However, the patch to *allow*
> Kprobes with DEBUG_RODATA is not, and will not be. It's not a regression,
> and quite frankly, I don't think I would even want that patch.
>
> Kprobes fundamntally disagrees with DEBUG_RODATA, there's no point in
> "working around it". Better just admit it.
>
>                 Linus
>
It depends on the purpose of DEBUG_RODATA.  If DEBUG_RODATA was for
security reasons then I agree, but it seems to be more to catch
accidental writes. Kprobes isn't an accidental write and I would
suspect many developers would want to catch accidental writes and be
able to insert kprobes.

Or is there something else I'm missing - i.e. you're saying the patch
itself is crap?

Ian

-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
