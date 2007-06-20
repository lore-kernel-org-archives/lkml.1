Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbXFTWio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbXFTWio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXFTWih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:38:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:41955 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXFTWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:38:36 -0400
Message-ID: <5640c7e00706201538n7a876deduba04e10cbbd55681@mail.gmail.com>
Date: Thu, 21 Jun 2007 10:38:35 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Miklos Szeredi" <miklos@szeredi.hu>, "Ingo Molnar" <mingo@elte.hu>,
       "Darrick J. Wong" <djwong@us.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "William Cohen" <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       "Antonino Daplas" <adaplas@gmail.com>, "Olaf Hering" <olaf@aepfle.de>,
       "=?ISO-8859-1?Q?Ville_Syrj=E4l=E4?=" <syrjala@sci.fi>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Soeren Sonnenburg" <kernel@nn7.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <4679AAD5.4030604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467543FA.60905@googlemail.com>
	 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com>
	 <4679AAD5.4030604@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> >> Subject    : CONFIG_DEBUG_RODATA prevents kprobes from working on
> >> 2.6.22-rc2
> >> References : http://lkml.org/lkml/2007/5/23/202
> >> Submitter  : William Cohen <wcohen@redhat.com>
> >>              Ian McDonald <ian.mcdonald@jandi.co.nz>
> >> Handled-By : S. P. Prasanna <prasanna@in.ibm.com>
> >> Patch      : http://lkml.org/lkml/2007/6/7/2
> >> Status     : patch available
>
> Patch was just merged:
>
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=55181000cd60334fe920c65ffbcdfe0e3f1de406
>

I see that just makes KPROBES and DEBUG_RODATA mutually exclusive
which makes sense for 2.6.22

Michal - don't kill this one so we have the full fix in 2.6.23

Ian
-- 
Web: http://wand.net.nz/~iam4/
Blog: http://iansblog.jandi.co.nz
WAND Network Research Group
