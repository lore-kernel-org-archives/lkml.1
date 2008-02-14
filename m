Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYBNU4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYBNU4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763808AbYBNUzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:55:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:25348 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYBNUzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:55:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=DoBMLfXq0iPQaVLF41NnXymdCbXNmPH0wIwod0apTR0i4u5S/jzmUt6qGUCKA0MUXDkX4Kk3C4Xw8Vl14331H5VnNjdaXU7Qe4OUVVpCmO96Fqs58sR2vuDOCQO1UBUMuPHID0ku1Rt7XPItmECxuloy2utypEXpSJGgGEUMAOo=
Message-ID: <2c0942db0802141255o5d18c6bfxe052ba9512a18817@mail.gmail.com>
Date: Thu, 14 Feb 2008 12:55:49 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clameter@sgi.com
In-Reply-To: <20080214103541.10943567.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
	 <2f11576a0802140611h261b9df2qd13406e562f52864@mail.gmail.com>
	 <20080214103541.10943567.pj@sgi.com>
X-Google-Sender-Auth: 7b219c3a515af7c0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 8:35 AM, Paul Jackson <pj@sgi.com> wrote:
> Kosaki-san wrote:
>  > i prefer another name [!relative].
>
>  Any suggestions?
>
>  I'll give the name some thought myself.
>  I like good names, and this is the right
>  time to get this one right.

'Relative map' implies a constant offset. What you have there is just
a map as relmap could be sparse (which, btw, would have been nice to
have in the example).

map_bitmap violates your naming convention, bitmap_map isn't all that
clear, bitmap_remap is taken, and while it is one-to-one and onto, I
think calling it bitmap_bijection would lose everyone except the
mathematicians. bitmap_onto? bitmap_map_onto? bitmap_map_bitmap_onto?

bitmap_read_my_kernel_doc?

Minor suggestion:
+ * and the n-th bit of @relmap is the m-th set bit of @relmap.

Perhaps s/is the/is also the/, so that the reader doesn't try to
second guess if you accidentally wrote @relmap twice instead of one of
them being @orig.
