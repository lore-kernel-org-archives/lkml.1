Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZAWPyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZAWPyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZAWPy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:54:28 -0500
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:23658 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753452AbZAWPy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:54:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jmKz7fOidOd+ceqiYQAsrpu1k5ut5MFbzmOmt3q9rJ5sB1ZdP/oNI3/+ON6QZL7jjOeL+8hoxEypFr5JUMnk1+MN6Irz5LwVnLt5Lh7woHti9GuZz0/nl2OG5hjhcAJI2utRZL1tFaozx2OtZrPnKSuIYuJwrJ6eVn71nkD7JUo=  ;
X-YMail-OSG: jY1gChkVM1l8F6ZyKKEbh2FttVWTkpnyfAFNYkugOm.pHFrsizUV7ThESJcaCWFWgPMwI9rJ1d6QuTZClP9TqaZvjbL_GhGwV8I8MlLNBP9mDxVU_nZpY5H3.Hvgq_5BTaxDyq7Si4f5IRzG_1gOyBv1VbgrLN2X6ub0M3Tw_iAYTiy8WJyfGSuybTdvgQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
Date: Sat, 24 Jan 2009 02:54:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240237.10522.nickpiggin@yahoo.com.au> <1232725468.6094.97.camel@penberg-laptop>
In-Reply-To: <1232725468.6094.97.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901240254.01552.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 02:44:28 Pekka Enberg wrote:
> On Sat, 2009-01-24 at 02:37 +1100, Nick Piggin wrote:
> > However, I don't know if netperf udp 4K over loopback is totally
> > realistic. Maybe real network drivers have different allocation patterns.
> > If I were you I wouldn't be too hasty to make big changes based on that
> > alone, if it could introduce regression in somewhere more important.
>
> Yup, I'm putting it in linux-next to see if anything pops up. It's of
> course possible that it will introduce regression somewhere but seeing
> the hit SLUB is taking from the page allocator, I'm bound to think that
> performance increase claims of commit
> aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through of
> page size or higher kmalloc requests") don't hold anymore.

Well what workload were they relating to? That could easily be retested.

