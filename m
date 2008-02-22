Return-Path: <linux-kernel-owner+w=401wt.eu-S933391AbYBVM3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391AbYBVM3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYBVM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:29:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:34095 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYBVM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:29:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dy6heMbjqNvhhxXGioKDDm03hxZHWk+neXizr1zPAEVKZ2+44HjGbsObp8pN8iUVWTgAwg7fX0o+e/xMR6qxOmdvJjalF7e587nOeA4udeaN1iAcGaJJTSUxPZ4+3HRwADI3wmIXo5iU3IkZKSUmsk3vjDEidMcclpLdmXryzo8=
Message-ID: <e2e108260802220429l5857c3edj351246ee31dd2a3e@mail.gmail.com>
Date: Fri, 22 Feb 2008 13:29:31 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Adrian Bunk" <bunk@kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Glenn Streiff" <gstreiff@neteffect.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Faisal Latif" <flatif@neteffect.com>
In-Reply-To: <47BE2985.6020305@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	 <20080221154951.GA28328@cs181133002.pp.htv.fi>
	 <adahcg2awag.fsf@cisco.com>
	 <20080221210124.GD28328@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	 <m3tzk1q3rt.fsf@maximus.localdomain>
	 <47BE2985.6020305@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 2:46 AM, David Newall <davidn@davidnewall.com> wrote:
> Krzysztof Halasa wrote:
>  > Perhaps we should increase line length limit, 132 should be fine.
>  > Especially useful with long printk() lines and long arithmetic
>  > expressions.
>
>  Yes; or even longer.  80 characters might have made sense on a screen
>  when the alternative was 80 characters on a punched card, but on a
>  modern computer it's very restrictive.  That's especially true with the
>  deep indents that you quickly get in C.  Even short lines often need to
>  be split when you put a few tabs in front of them, and that makes
>  comprehension that bit harder, not to mention looks ugly.

There is a reason to limit line length: scientific research has shown
that readability of regular texts is optimal for a line length between
55 and 65 characters. My experience is that the readability of source
code decreases when the lines are very long (more than 160
characters).

Bart Van Assche.
