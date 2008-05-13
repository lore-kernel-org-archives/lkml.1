Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbYEMPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbYEMPbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbYEMPbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:31:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:62433 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760720AbYEMPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JaWXvK5SUviFe0B2GfYhLiRlimAXtMey/q/0gNyGf3ziAxtSvp1sTkXE41w3yyvzYTYn48FVJUX1TToYDyeBJRpO+0WtyyCu0OADong3SvzJd9amnS0Xq60/Xo3PffF5rPoE4KPgDXEvxlE3pMLJnu9eIHR2gOvZGilNGUkDmUo=
Message-ID: <19f34abd0805130831w6887e797jdc5e636eee3a0137@mail.gmail.com>
Date: Tue, 13 May 2008 17:31:20 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC/PATCH] printk: detect incomplete lines
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rob Landley" <rob@landley.net>
In-Reply-To: <87ej86scdc.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512114925.GA29407@damson.getinternet.no>
	 <84144f020805120456r14436eend416e079ea88be9c@mail.gmail.com>
	 <19f34abd0805120500k7613dbd9le1bf79f7bb96778a@mail.gmail.com>
	 <87ej86scdc.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 12:54 PM, Andi Kleen <andi@firstfloor.org> wrote:
> "Vegard Nossum" <vegard.nossum@gmail.com> writes:
>  >
>  > Iirc, KERN_CONT is mostly an annotation for the checkpatch script to
>  > suppress the warning about missing loglevel token.
>
>  Perhaps it should be fixed to contain some magic token that is
>  then detected by printk and handled appropiately? And then perhaps
>  employee some kernel janitors to add it everywhere?
>
>  I think that would be preferable over any heuristics as implemented
>  in your original patch because there might be a legitimate need to
>  get out non full line printks ASAP for debugging.

I'm sorry, I don't understand what you mean. My original patch does
not delay anything. My original patch simply inserts a newline before
the next printk() if the caller is different and the current line is
unterminated.

What would be the purpose of the magic token? Please explain.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
