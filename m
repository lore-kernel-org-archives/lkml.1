Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXGYW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXGYW24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbXGYW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:28:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:51741 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbXGYW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sZ1c20/nFph9v/feSZYZ6aPZMNxuS/pvtf3dqT72Pr7PoQTJXBzr0pEHpafj02Aclu77F/9E8a8ccMKuj0zUgDOmlIBgEP41BREuplvKpZp/C7Iv6I0FqWZy95LMuTWgGH6eRp/Um9FGoAyVRatYwueAirFjjksHQ37QWUxUZ5A=
Message-ID: <b14e81f00707251528i275b0f6by235acce2d5b83473@mail.gmail.com>
Date: Wed, 25 Jul 2007 18:28:46 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, david@lang.hm, nickpiggin@yahoo.com.au,
       Valdis.Kletnieks@vt.edu, ray-lk@madrabbit.org, jesper.juhl@gmail.com,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, rene.herman@gmail.com
In-Reply-To: <20070725150509.4d80a85e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A58B49.3050508@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com>
	 <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com>
	 <20070725113401.GA23341@elte.hu> <20070725150509.4d80a85e.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Paul Jackson <pj@sgi.com> wrote:
> Question:
>   Could those who have found this prefetch helps them alot say how
>   many disks they have?  In particular, is their swap on the same
>   disk spindle as their root and user files?

I have found that swap prefetch helped on all of the four machines
machine I have, although the effect is more noticeable on machines
with slower disks. They all have one hard disk, and root and swap were
always on the same disk. I have no idea how to determine how many disk
spindles they have, but since the drives are mainly low-end consumer
models sold with low-end sub $500 PCs...

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
