Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYGaWCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYGaWCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbYGaWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:02:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:1757 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbYGaWC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=foHdxv43DZUxTr0bYZe1tdn9fal+NR5rlkI854HDUmC+YxJ+awDOE9vzWGrzX8N8KA
         SsLQK7/D3dcdVdRvwn1f1ylCWUqv5vbkdI2UB379xbZVGaz/WJGLtW1g09k+ym1A3Fef
         zLP1XcoArq5O6TUawqrzMAO999mArFqIUMS2w=
Message-ID: <b647ffbd0807311502i48dbe916l41e417e1e3941160@mail.gmail.com>
Date: Fri, 1 Aug 2008 00:02:27 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Peter Oruba" <peter.oruba@amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>
In-Reply-To: <20080731212701.GG2729@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com> <20080731212701.GG2729@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/31 Ingo Molnar <mingo@elte.hu>:
>
> * Peter Oruba <peter.oruba@amd.com> wrote:
>
>> Fixed coding style issues.
>
> applied to tip/x86/microcode - thanks Peter.
>
> Will you take a shot at moving the driver to early init (and early SMP
> init) code, as suggested by Dmitry?

I have another fix for 'microcode' (one place may race vs.
sched_setaffinity()) and a few ideas/improvements to try. I would also
do this 'move-cpu-hotplug-activities-to-early-init' thing (but
perhaps, not earlier than on Saturday-Sunday) if Peter doesn't come up
with a patch by this time.

btw., is tip/x86/microcode a .27 material? I mean, if I do some work,
should I do it on top of the current linus-git or -tip (or both)?


>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
