Return-Path: <linux-kernel-owner+w=401wt.eu-S1762135AbXHJXZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762135AbXHJXZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXHJXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:25:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:6333 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXHJXZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E5dR8t88pUpW4drRoNACoM1RgDSe96oeM8znPU7Dc/XzMdIyxK2X/SsYVcPakybq87ME1PE5n10bdVMQfUzd+Mjkjxh1D+QZZM9M3P2RVyR7874z0mrXkRKy3db/wnjfpv131xHbnrnVeNuYUvanStl3RVKV5DbgkXHXFKsbH+0=
Message-ID: <4a5909270708101625q407a240ck6109ef536fdbed4a@mail.gmail.com>
Date: Fri, 10 Aug 2007 19:25:34 -0400
From: "Daniel Phillips" <daniel.raymond.phillips@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Cc: "Daniel Phillips" <phillips@phunq.net>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Phillips" <phillips@google.com>
In-Reply-To: <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806102922.907530000@chello.nl>
	 <Pine.LNX.4.64.0708081106230.12652@schroedinger.engr.sgi.com>
	 <4a5909270708091141tb259eddyb2bba1270751ef1@mail.gmail.com>
	 <Pine.LNX.4.64.0708091146410.25220@schroedinger.engr.sgi.com>
	 <4a5909270708091717n2f93fcb5i284d82edfd235145@mail.gmail.com>
	 <Pine.LNX.4.64.0708091844450.3185@schroedinger.engr.sgi.com>
	 <4a5909270708092034yaa0a583w70084ef93266df48@mail.gmail.com>
	 <Pine.LNX.4.64.0708092045120.27164@schroedinger.engr.sgi.com>
	 <4a5909270708100115v4ad10c4es697d216edf29b07d@mail.gmail.com>
	 <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Christoph Lameter <clameter@sgi.com> wrote:
> The idea of adding code to deal with "I have no memory" situations
> in a kernel that based on have as much memory as possible in use at all
> times is plainly the wrong approach.

No.  It is you who have read the patches wrongly, because what you
imply here is exactly backwards.

> If you need memory then memory needs
> to be reclaimed. That is the basic way that things work

Wrong.  A naive reading of your comment would suggest you do not
understand how PF_MEMALLOC works, and that it has worked that way from
day one (well, since long before I arrived) and that we just do more
of the same, except better.

> and following that
> through brings about a much less invasive solution without all the issues
> that the proposed solution creates.

What issues?  Test case please, a real one that you have run yourself.
 Please, no more theoretical issues that cannot be demonstrated in
practice because they do not exist.

Regards,

Daniel
